function scatterhist(X,Y,varargin)

assert(isvector(X),'X should be a vector')
assert(isvector(Y),'Y should be a vector')


warning('off','MATLAB:polyshape:repairedBySimplify')

options.AxisColor = color.aqua('gray');
options.Color = color.aqua('pink');
options.LineWidth = 2;
options.IgnoreBelow = .01;
options.NumBins = 100;


options = corelib.parseNameValueArguments(options,varargin{:});

structlib.packUnpack(options)

X = X(:);
Y = Y(:);

X(X<IgnoreBelow) = 0;
Y(Y<IgnoreBelow) = 0;

assert(length(X) == length(Y),'Size mismatch')


% ignore what needs to be ignored
rm_this = isnan(X) | isnan(Y);
X(rm_this) = [];
Y(rm_this) = [];


% first make the simple scatter plot
plot(X,Y,'.','Color',Color)


% estimate densities by binning
% S = histcounts2(X,Y,1e3);
% S = (imgaussfilt(S,10));
% [XX,YY] = meshgrid(linspace(min(X),max(X),1000),linspace(min(Y),max(Y),1000));
% [C,h]=contour(XX,YY,S',logspace(-2,0,7),'EdgeColor','k');
% h.LineStyle = 'none';
% h.Fill = 'on';

hold on
% get the percentiles
qX = prctile(X,0:20:100);
qY = prctile(Y,0:20:100);


% erase axes
ax = get(gca);

x_pos = qY(end)-(qY(end)-qY(1))*1.1;
y_pos = qX(end)-(qX(end)-qX(1))*1.1;

x_height = (qY(end)-qY(1))*.2;
y_height = (qX(end)-qX(1))*.2;

ax = gca;
ax.XLim(1) = y_pos;
ax.YLim(1) = x_pos;


% make the range markers
% plot([qX(1) qX(end)],[x_pos x_pos],'Color',AxisColor,'LineWidth',2)
% plot([y_pos y_pos],[qY(1) qY(end)],'Color',AxisColor,'LineWidth',2)


% marginal X
[hX, edges] = histcounts(X,options.NumBins);
bincenters = edges(1:end-1) + (edges(2)-edges(1))/2;
bincenters = [bincenters(1) bincenters bincenters(end)];
hX = [0 hX 0];


hX = hX/max(hX);
hX = hX*x_height;
ph = plot(polyshape(bincenters,max(Y)*1.05+hX));
ph.FaceColor = AxisColor;
ph.EdgeColor = AxisColor;
ph.FaceAlpha = .35;




% marginal Y
[hY, edges] = histcounts(Y,options.NumBins);
bincenters = edges(1:end-1) + (edges(2)-edges(1))/2;
bincenters = [bincenters(1) bincenters bincenters(end)];
hY = [0 hY 0];
hY = hY/max(hY);
hY = hY*y_height;

ph = plot(polyshape(max(X)*1.05+hY,bincenters));
ph.FaceColor = AxisColor;
ph.EdgeColor = AxisColor;
ph.FaceAlpha = .35;

ax.XLim(2) = max(X)*1.05 + max(hY);
ax.YLim(2) = max(Y)*1.05 + max(hX);


ax.XTick(ax.XTick<min(X)) = [];
ax.XTick(ax.XTick>max(X)) = [];
ax.YTick(ax.YTick<min(Y)) = [];
ax.YTick(ax.YTick>max(Y)) = [];


ax.XTick = unique([min(X) ax.XTick max(X)]);
ax.YTick = unique([min(Y) ax.YTick max(Y)]);


% markers to indicate ranges

% th = text(qX(end)*1.01,y_pos-y_height,corelib.num2tex(qX(end)),'FontSize',16,'HorizontalAlignment','left','Rotation',0);

% th = text(qX(1)*.99,y_pos-y_height,corelib.num2tex(qX(1)),'FontSize',16,'HorizontalAlignment','right','Rotation',0);


% th = text(x_pos-x_height*.1,qY(end),corelib.num2tex(qY(end)),'FontSize',16,'HorizontalAlignment','right','Rotation',0);



% th = text(x_pos-x_height*.1,qY(1),corelib.num2tex(qY(1)),'FontSize',16,'HorizontalAlignment','right');



warning('on','MATLAB:polyshape:repairedBySimplify')


% hide pointless parts of the axes

plot([ax.XLim(1) min(X)],[ax.YLim(1) ax.YLim(1)],'w','LineWidth',3)
plot([ax.XLim(1) ax.XLim(1)],[ax.YLim(1) min(Y)],'w','LineWidth',3)

plot([max(X) ax.XLim(2)],[ax.YLim(1) ax.YLim(1)],'w','LineWidth',3)
plot([ax.XLim(1) ax.XLim(1)],[ max(Y) ax.YLim(2)],'w','LineWidth',3)
box off