function R = findBoundaries(self, make_plot)

if ~iscategorical(self.data.values)
	error('Cannot compute boundaries when output is non-categorical')
end

warning('off','MATLAB:polyshape:repairedBySimplify')

if nargin < 2
	make_plot = false;
end

[X,Y] = self.normalize;


self.DT = delaunayTriangulation(X,Y);

% define a large raster matrix 
R = categorical(NaN(1e3,1e3));
R = R(:);

% make a list of all the points here
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);

[all_x,all_y] = meshgrid(all_x,all_y);
all_x = all_x(:);
all_y = all_y(:);

DT = self.DT;
for i = 1:size(DT,1)

	inp = inpolygon(all_x,all_y,X(DT.ConnectivityList(i,:)),Y(DT.ConnectivityList(i,:)));

	if length(unique(self.data.values(DT.ConnectivityList(i,:)))) == 1
	

		% OK, all the same
		
		R(inp) = self.data.values(DT.ConnectivityList(i,1));


	else
		R(inp) = mode(self.data.values(DT.ConnectivityList(i,:)));

	end
end


% fill in NaNs using interpolation


R = -grp2idx(R(:));

R0 = -grp2idx(self.data.values);



Vq = interp2(X,Y,R0,all_x,all_y);


R = reshape(R,1e3,1e3);
all_x = linspace(0,1,1e3);
all_y = linspace(0,1,1e3);


for i = 1:1e3
	for j = 1:1e3
		if ~isnan(R(i,j))
			continue
		end
		[~,idx]=min((X - all_x(j)).^2 + (Y - all_y(i)).^2);
		R(i,j) = R0(idx);
	end
end

R = R';

n_classes = length(categories(self.data.values));
self.traceBoundaries(R, n_classes);

self.plotBoundaries(make_plot, n_classes);


warning('on','MATLAB:polyshape:repairedBySimplify')

