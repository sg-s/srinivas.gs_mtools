function plotBoundaries(self,make_plot, n_classes, ColorMap, FaceAlpha)

if nargin < 4
	ColorMap = lines;
end


if nargin < 5
	FaceAlpha = .35;
end

warning('off','MATLAB:polyshape:repairedBySimplify')

if isa(make_plot,'matlab.graphics.axis.Axes')
	plot_here =  make_plot;
elseif islogical(make_plot) && make_plot
	figure('outerposition',[300 300 601 600],'PaperUnits','points','PaperSize',[601 600]); hold on
	plot_here = gca;
	hold on
else
	return
end


if strcmp(self.XScale,'log')
	set(plot_here,'XScale','log')
end
if strcmp(self.YScale,'log')
	set(plot_here,'YScale','log')
end

for i = 1:n_classes
	for j = 1:length(self.boundaries(i).regions)
		bx = self.boundaries(i).regions(j).x;
		by = self.boundaries(i).regions(j).y;
		ph = plot(plot_here,polyshape(bx,by));
		ph.FaceColor = ColorMap(i,:);
		ph.FaceAlpha = FaceAlpha;
		self.handles.regions(i).patches(j) = ph;
	end
end


plot_here.XLim = [self.Lower(1) self.Upper(1)];
plot_here.YLim = [self.Lower(2) self.Upper(2)];


warning('on','MATLAB:polyshape:repairedBySimplify')