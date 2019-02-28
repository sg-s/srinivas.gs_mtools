function findBoundaries(self, make_plot)

warning('off','MATLAB:polyshape:repairedBySimplify')

if nargin < 2
	make_plot = false;
end

% work in normalized co-ordinates
[X,Y] = self.normalize;


self.DT = delaunayTriangulation(X,Y);

% define a large raster matrix 
R = NaN(1e3,1e3);
R = R(:);

% make a list of all the points here
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);

[all_x,all_y] = meshgrid(all_x,all_y);
all_x = all_x(:);
all_y = all_y(:);

DT = self.DT;
for i = 1:size(DT,1)
	if min(self.R(DT.ConnectivityList(i,:))) == max(self.R(DT.ConnectivityList(i,:)))
		
		% OK, all the same
		inp = inpolygon(all_x,all_y,X(DT.ConnectivityList(i,:)),Y(DT.ConnectivityList(i,:)));
		R(inp) = min(self.R(DT.ConnectivityList(i,:)));



	end
end

% fill in NaNs using nearest neighbors
R = reshape(R,1e3,1e3);
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);


for i = 1:1e3
	for j = 1:1e3
		if ~isnan(R(i,j))
			continue
		end
		[~,idx]=min((X - all_x(j)).^2 + (Y - all_y(i)).^2);
		R(i,j) = self.R(idx);
		self.R(idx);

	end

end
R = R';


if strcmp(self.x_scale,'log')
	all_x = logspace(log10(self.x_range(1)),log10(self.x_range(2)),1e3);
else
	all_x = linspace(self.x_range(1),self.x_range(2),1e3);
end
if strcmp(self.y_scale,'log')
	all_y = logspace(log10(self.y_range(1)),log10(self.y_range(2)),1e3);
else
	all_y = linspace(self.y_range(1),self.y_range(2),1e3);
end


% ok, we now have a labeled, rasterized image
% find the boundaries of each class of data
for i = 1:self.n_classes

	this_R = (R==i);

	% check if there are multiple connected components
	% in this map
	L = bwlabel(this_R);
	n_comp = length(unique(L(:))) - 1;

	
	for j = 1:n_comp
		% trace boundaries
		B = bwboundaries(L == j);
		bx = B{1}(:,1);
		by = B{1}(:,2);

		% un-normalize
		self.boundaries(i).regions(j).x = all_x(bx);
		self.boundaries(i).regions(j).y = all_y(by);
	end


end



% % now find boundaries the traditional way
% incenters = incenter(DT);
% boundary_pts = NaN(size(DT.ConnectivityList,1),2);
% for i = 1:size(DT.ConnectivityList,1)
% 	% only if the vertices are different 
% 	if min(self.R(DT.ConnectivityList(i,:))) == max(self.R(DT.ConnectivityList(i,:)))
% 		continue
% 	end

% 	% OK, at least one different
% 	boundary_pts(i,:) = incenters(i,:);

% 	[boundary_pts(i,1),boundary_pts(i,2)] = self.deNormalize(boundary_pts(i,1),boundary_pts(i,2));

% end





if isa(make_plot,'matlab.graphics.axis.Axes')
	plot_here =  make_plot;
elseif islogical(make_plot) && make_plot
	figure('outerposition',[300 300 601 600],'PaperUnits','points','PaperSize',[601 600]); hold on
	plot_here = gca;
	hold on
else
	return
end

c = lines;

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
		ph.FaceColor = c(i,:);
	end
end


plot_here.XLim = self.x_range;
plot_here.YLim = self.y_range;


warning('on','MATLAB:polyshape:repairedBySimplify')

