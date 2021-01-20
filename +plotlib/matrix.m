% plots a matrix in a sane fashion
% with accurate X and Y ticks
% this is a better version of heatmap
function matrix(Z,X,Y,XTicks, YTicks)

arguments
	Z double
	X (:,1) double
	Y (:,1) double
	XTicks (:,1) double
	YTicks (:,1) double
end

assert(ismatrix(Z),'Z must be a matrix')
assert(size(Z,1) == length(X),'X is the wrong size')
assert(size(Z,2) == length(Y),'Y is the wrong size')


imagesc(Z)

set(gca,'XLim',[.5 size(Z,2)+.5])
set(gca,'YLim',[.5 size(Z,1)+.5])

x = 1:size(Z,1);
XTickLocs = interp1(X,x,XTicks);
rm_this = isnan(XTickLocs);
XTicks(rm_this) = [];
XTickLocs(rm_this) = [];
set(gca,'YTick',XTickLocs,'YTickLabels',XTicks)

y = 1:size(Z,2);
YTickLocs = interp1(Y,y,YTicks);
rm_this = isnan(YTickLocs);
YTicks(rm_this) = [];
YTickLocs(rm_this) = [];
set(gca,'XTick',YTickLocs,'XTickLabels',YTicks)