% draw a diagonal line on a plot
function ph = drawDiag(ax, varargin)

if nargin == 0
	ax = gca;
end

x = ax.XLim;
y = ax.YLim;

M = max([max(x) max(y)]);

hold(ax,'on');

if x(1) > 0 && x(2) > 0
	X = logspace(log10(eps),log10(M),1e3);
else
	X = linspace(min([x(1) y(1)]),(M),1e3);
end


if isempty(varargin)
	ph = plot(ax,X,X,'k--');
else
	ph = plot(ax,X,X,varargin{:});
end

uistack(ph,'top')

