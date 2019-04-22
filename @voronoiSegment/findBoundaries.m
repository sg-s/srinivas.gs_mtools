function R = findBoundaries(self, make_plot)

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


self.traceBoundaries(R);

self.plotBoundaries(make_plot);


warning('on','MATLAB:polyshape:repairedBySimplify')

