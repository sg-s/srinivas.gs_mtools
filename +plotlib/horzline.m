% draws a horizontal line on the specified axis
function lh = horzline(varargin)

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

Y = varargin{1};
varargin(1) = [];

X = ax.XLim;

lh = plot(ax,X,[Y,Y],varargin{:});