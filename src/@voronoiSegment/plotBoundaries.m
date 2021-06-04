function plotBoundaries(self,make_plot, ColorMap, FaceAlpha)

if nargin < 3
	ColorMap = lines;
end


if nargin < 4
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


if strcmp(self.x_scale,'log')
	set(plot_here,'XScale','log')
end
if strcmp(self.y_scale,'log')
	set(plot_here,'YScale','log')
end

for i = 1:self.n_classes
	for j = 1:length(self.boundaries(i).regions)
		bx = self.boundaries(i).regions(j).x;
		by = self.boundaries(i).regions(j).y;
		ph = plot(plot_here,polyshape(bx,by));
		ph.FaceColor = ColorMap(i,:);
		ph.FaceAlpha = FaceAlpha;
		self.handles.regions(i).patches(j) = ph;
	end
end


plot_here.XLim = self.x_range;
plot_here.YLim = self.y_range;


warning('on','MATLAB:polyshape:repairedBySimplify')