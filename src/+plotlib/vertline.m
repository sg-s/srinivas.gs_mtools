% draws a vertical line on the specified axis
function lh = vertline(varargin)

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

X = varargin{1};
varargin(1) = [];
X = X(:);


if length(X) > 1
	X = veclib.interleave(X,X,X*NaN);
	Y = NaN*X;
	Y(1:3:end) = ax.YLim(1);
	Y(2:3:end) = ax.YLim(2);
	lh = plot(ax,X,Y, varargin{:});

else
	Y = ax.YLim;
	lh = plot(ax,[X,X],Y, varargin{:});
	
end



