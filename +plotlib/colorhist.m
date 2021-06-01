% plots a histogram that also serves as a colorbar
function p = colorhist(ax, X, options)

arguments
	ax (1,1) matlab.graphics.axis.Axes
	X (:,1) double
	options.BinLimits = [];
	options.NumBins = 50;
end


if isempty(options.BinLimits)
	options.BinLimits = [min(X) max(X)];
end

[hy,hx] = histcounts(X,'BinLimits',options.BinLimits,'NumBins',options.NumBins,'Normalization','pdf');


min_value = min(hy(hy>0));
hy = [0 hy 0];
hx = [hx hx(end)];
hy(hy==0) = min_value;

p = patch(ax,hx,hy,1:length(hx));
p.LineWidth = 1.5;