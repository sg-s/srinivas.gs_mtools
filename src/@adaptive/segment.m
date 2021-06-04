% segments space into categories
% and find boundaries of every region for every category


function segment(self, make_plot)

if ~iscategorical(self.data.values)
	error('Cannot compute boundaries when output is non-categorical')
end

warning('off','MATLAB:polyshape:repairedBySimplify')

if nargin < 2
	make_plot = false;
end

[X,Y] = self.normalize;


DT = delaunayTriangulation(X,Y);

% define a large raster matrix 
R = categorical(NaN(1e3,1e3));
R = R(:);

% make a list of all the points here
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);

[all_x,all_y] = meshgrid(all_x,all_y);
all_x = all_x(:);
all_y = all_y(:);


for i = 1:size(DT,1)
	inp = inpolygon(all_x,all_y,X(DT.ConnectivityList(i,:)),Y(DT.ConnectivityList(i,:)));
	R(inp) = mode(self.data.values(DT.ConnectivityList(i,:)));
end




R = grp2idx(R(:));
R0 = grp2idx(self.data.values);



R = reshape(R,1e3,1e3);
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);


for i = 1:1e3
	for j = 1:1e3
		if ~isnan(R(i,j))
			continue
		end

		error('not coded')

		[~,idx]=min((X - all_x(j)).^2 + (Y - all_y(i)).^2);
		R(i,j) = R0(idx);
	end
end

R = R';


n_classes = length(categories(self.data.values));

% ok, we now have a labeled, rasterized image
% find the boundaries of each class of data
for i = 1:n_classes

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
