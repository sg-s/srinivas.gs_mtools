% draws a vertical line on the specified axis
function lh = vertline(varargin)

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

X = varargin{1};

Y = ax.YLim;

lh = plot(ax,[X,X],Y);