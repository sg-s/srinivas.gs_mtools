function drawDiag()

ax = gca;

x = ax.XLim;
y = ax.YLim;

M = max([max(x) max(y)]);

hold(ax,'on');

plot(ax,[0 M],[0 M],'k--');

