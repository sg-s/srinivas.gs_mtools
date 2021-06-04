% draw a diagonal line on a plot
function ph = drawDiag(ax, varargin)

if nargin == 0
	ax = gca;
end

x = ax.XLim;
y = ax.YLim;

M = max([max(x) max(y)]);

hold(ax,'on');

X = logspace(log10(eps),log10(M),1e3);

if length(varargin) == 0
	ph = plot(ax,X,X,'k--');
else
	ph = plot(ax,X,X,varargin{:});
end

uistack(ph,'top')

