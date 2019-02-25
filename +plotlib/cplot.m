% plots X and Y dots and colors each dot
% by a value V
% X, Y and V should be vectors of the same length
% 
% usage:
% handles = cplot(X,Y,Z);
% handles = cplot(ax,X,Y,Z);
% 
function varargout = cplot(varargin)

assert(nargin >= 3, 'Not enough input arguments')

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

X = varargin{1};
Y = varargin{2};
Z = varargin{3};

X = X(:);
Y = Y(:);
Z = Z(:);

% purge NaNs
rm_this = isnan(Z) | isnan(X) | isnan(Y);
X(rm_this) = [];
Y(rm_this) = [];
Z(rm_this) = [];

varargin(1:3) = [];

% options and defaults
options.clim = [NaN NaN];
options.use_scatter = true;
options.n_colors = NaN;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
if mathlib.iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end

assert(length(X) == length(Y),'Vectors not of equal length')
assert(length(X) == length(Z),'Vectors not of equal length')


if options.use_scatter
	% make color scheme
	if isnan(options.clim(1))
		C = Z - min(Z);
		C = C/max(C);
		C = floor(C*999 + 1);
	else
		C = Z - options.clim(1);
		C = C/options.clim(2);
		C = floor(C*999 + 1);
	end

	c = parula(1e3);

	scatter_handle = scatter(ax,X,Y,24,c(C,:),'filled');

	scatter_handle.Marker = 's';

	chandle = colorbar(ax);
	caxis(ax,[min(Z) max(Z)])


	if nargout == 0
	elseif nargout == 1
		varargout{1} = scatter_handle;
	elseif nargout == 2
		varargout{1} = scatter_handle;
		varargout{2} = chandle;
	else
		error('Too many outputs requested')
	end

else
	% discretize the colormap and make N different plots
	% with those colors

	assert(~isnan(options.n_colors),'n_colors must be specified')

	% discretize colors
	C = Z - min(Z);
	C = C/max(C);
	C = floor(C*(options.n_colors-1))+1;
	c = parula(options.n_colors);

	for i = options.n_colors:-1:1
		plot_handles(i) = plot(X(C==i),Y(C==i),'.','Color',c(i,:));
	end

	chandle = colorbar(ax);
	caxis(ax,[min(Z) max(Z)])

	if nargout == 0
	elseif nargout == 1
		varargout{1} = plot_handles;
	elseif nargout == 2
		varargout{1} = plot_handles;
		varargout{2} = chandle;
	else
		error('Too many outputs requested')
	end

end