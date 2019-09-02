% plots X and Y dots and colors each dot by a value V
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
options.colormap = 'parula';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});

assert(length(X) == length(Y),'Vectors not of equal length')
assert(length(X) == length(Z),'Vectors not of equal length')


if length(X) == 0
	varargout{1} = [];
	varargout{2} = [];
	return
end

if options.use_scatter
	% make color scheme
	if isnan(options.clim(1))
		C = Z - min(Z);
		C = C/max(C);
		C = floor(C*999 + 1);
	else
		C = Z - options.clim(1);
		C = C/(options.clim(2)-options.clim(1));
		C = floor(C*999 + 1);

		assert(min(C) > 0,'Using the clim you specified leads to out of range array elements. Choose a better clim, or specify NaN to use automatic range detection')


	end

	eval(['c = ' options.colormap '(1e3);']);

	% force to bounds
	C(C>1e3)  =1e3;
	C(C<1) = 1;

	scatter_handle = scatter(ax,X,Y,24,c(C,:),'filled');


	scatter_handle.Marker = 'o';

	colormap(ax,options.colormap);
	chandle = colorbar(ax);
	if isnan(options.clim(1))
		caxis(ax,[min(Z) max(Z)])
	else
		caxis(ax,options.clim)
	end


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


	% discretize colors
	NColors = length(options.colormap);
	C = Z - options.clim(1);
	C = C/(diff(options.clim));
	C = floor(C*NColors);
	C(C<1) = 1;
	C(C>NColors) = NColors;

	
	clear plot_handles
	for i = NColors:-1:1
		if any(C==i)
			plot_handles(i) = plot(ax,X(C==i),Y(C==i),'.','Color',options.colormap(i,:));
		end
	end

	chandle = colorbar(ax);
	caxis(ax,options.clim)

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