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
options.CLim = [NaN NaN];
options.BinCenters = NaN;
options.UseScatter = true;
options.colormap = @parula;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});


if ~isnan(options.BinCenters)
	% override UseScatter
	options.UseScatter = false;
end


assert(isa(options.colormap,'function_handle'),'colormap should be a function handle')

assert(length(X) == length(Y),'Vectors not of equal length')
assert(length(X) == length(Z),'Vectors not of equal length')


if length(X) == 0
	varargout{1} = [];
	varargout{2} = [];
	return
end

if options.UseScatter
	% make color scheme
	if isnan(options.CLim(1))
		C = Z - min(Z);
		C = C/max(C);
		C = floor(C*999 + 1);
	else
		C = Z - options.CLim(1);
		C = C/(options.CLim(2)-options.CLim(1));
		C = floor(C*999 + 1);

		assert(min(C) > 0,'Using the CLim you specified leads to out of range array elements. Choose a better CLim, or specify NaN to use automatic range detection')


	end

	c = options.colormap(1e3);

	% force to bounds
	C(C>1e3) = 1e3;
	C(C<1) = 1;

	scatter_handle = scatter(ax,X,Y,24,c(C,:),'filled');


	scatter_handle.Marker = 'o';

	colormap(ax,options.colormap);
	chandle = colorbar(ax);
	if isnan(options.CLim(1))
		caxis(ax,[min(Z) max(Z)])
	else
		caxis(ax,options.CLim)
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

	if isnan(options.BinCenters)
		disp('BinCenters not specified')
		keyboard
	end


	% discretize colors
	bin_edges = unique([options.CLim options.BinCenters(1:end-1) + diff(options.BinCenters)/2]);
	idx = discretize(Z,bin_edges);

	% to do: handle NaN  idx
	if any(isnan(idx))
		warning('NaNs in idx, which will be ignored')
	end

	% create a discrete colormap from whatever colormap
	% we are given 
	C = options.colormap(1e3);

	plot_colors_idx = floor(1+999*((options.BinCenters - options.CLim(1))/(diff(options.CLim))));
	plot_colors = C(plot_colors_idx,:);


	temp = discretize(1:1e3,unique([1 plot_colors_idx(1:end-1) + diff(plot_colors_idx)/2 1e3]));
	temp(temp>length(plot_colors)) = length(plot_colors);
	C = C(plot_colors_idx(temp),:);
	
	clear plot_handles
	for i = length(plot_colors):-1:1
		if any(idx==i)
			plot_handles(i) = plot(ax,X(idx==i),Y(idx==i),'.','Color',plot_colors(i,:));
		end
	end

	chandle = colorbar(ax);
	caxis(ax,options.CLim)
	colormap(ax,C)
	chandle.Ticks = options.BinCenters;

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