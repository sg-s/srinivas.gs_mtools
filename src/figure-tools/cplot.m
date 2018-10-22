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

assert(length(X) == length(Y),'Vectors not of equal length')
assert(length(X) == length(Z),'Vectors not of equal length')

% make color scheme
C = Z - min(Z);
C = C/max(C);
C = floor(C*999 + 1);

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