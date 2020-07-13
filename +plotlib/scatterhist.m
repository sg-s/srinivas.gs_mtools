function scatterhist(X,Y,varargin)

assert(isvector(X),'X should be a vector')
assert(isvector(Y),'Y should be a vector')


AxisColor = color.aqua('gray');
Color = color.aqua('pink');
LineWidth = 2;

X = X(:);
Y = Y(:);

assert(length(X) == length(Y),'Size mismatch')


% ignore what needs to be ignored
rm_this = isnan(X) | isnan(Y);
X(rm_this) = [];
Y(rm_this) = [];
 
% first make the simple scatter plot
plot(X,Y,'.','Color',Color)


% estimate densities by binning
S = histcounts2(X,Y,1e3);
S = (imgaussfilt(S,10));
[XX,YY] = meshgrid(linspace(min(X),max(X),1000),linspace(min(Y),max(Y),1000));
[C,h]=contour(XX,YY,S',logspace(-2,0,7),'EdgeColor','k');
h.LineStyle = 'none';
h.Fill = 'on';


% get the percentiles
qX = prctile(X,0:20:100);
qY = prctile(Y,0:20:100);


% erase axes
ax = get(gca);
set(gca,'Visible','off')

x_pos = qY(end)-(qY(end)-qY(1))*1.1;
y_pos = qX(end)-(qX(end)-qX(1))*1.1;

x_height = (qY(end)-qY(1))*.15;
y_height = (qX(end)-qX(1))*.15;

ax = gca;
ax.XLim(1) = y_pos - y_height;
ax.YLim(1) = x_pos - x_height;


% make the range markers
plot([qX(1) qX(end)],[x_pos x_pos],'Color',AxisColor,'LineWidth',2)
plot([y_pos y_pos],[qY(1) qY(end)],'Color',AxisColor,'LineWidth',2)


% marginal X
[hX, edges] = histcounts(X,1e2);
bincenters = edges(1:end-1) + (edges(2)-edges(1))/2;
bincenters = [bincenters bincenters(1)];
hX = [hX 0];


hX = hX/max(hX);
hX = hX*x_height;
ph = plot(polyshape(bincenters,x_pos-hX));
ph.FaceColor = AxisColor;
ph.EdgeColor = AxisColor;
ph.FaceAlpha = 1;




% marginal Y
[hY, edges] = histcounts(Y,1e2);
bincenters = edges(1:end-1) + (edges(2)-edges(1))/2;
bincenters = [bincenters bincenters(1)];
hY = [hY 0];
hY = hY/max(hY);
hY = hY*y_height;

ph = plot(polyshape(y_pos-hY,bincenters));
ph.FaceColor = AxisColor;
ph.EdgeColor = AxisColor;
ph.FaceAlpha = 1;

% markers to indicate ranges

th = text(qX(end)*1.01,y_pos-y_height,corelib.num2tex(qX(end)),'FontSize',16,'HorizontalAlignment','left','Rotation',0);

th = text(qX(1)*.99,y_pos-y_height,corelib.num2tex(qX(1)),'FontSize',16,'HorizontalAlignment','right','Rotation',0);


th = text(x_pos-x_height*.1,qY(end),corelib.num2tex(qY(end)),'FontSize',16,'HorizontalAlignment','right','Rotation',0);



th = text(x_pos-x_height*.1,qY(1),corelib.num2tex(qY(1)),'FontSize',16,'HorizontalAlignment','right');

