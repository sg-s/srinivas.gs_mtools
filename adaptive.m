classdef adaptive < ConstructableHandle


properties

	SampleFcn@function_handle
	Lower
	Upper

	MaxIter@double = 200

	MakePlot@logical = true

	BatchSize@double = 12

	UseParallel@logical = false

	PlotHere

end


properties (SetAccess = private) 

	% stores the triangulation
	DT@delaunayTriangulation

	SamplePoints
	data
	handles
end



methods


	function self = adaptive(varargin)

	
		% if self.UseParallel
		% 	pool = gcp;
		% 	self.BatchSize = 2*pool.NumWorkers;
		% end

		self = self@ConstructableHandle(varargin{:});  


		
	end % constructor


	function sample(self)

		self.Upper = self.Upper(:);
		self.Lower = self.Lower(:);

		% number of dimensions
		N = length(self.Upper);

		% make the figure
		if isempty(self.PlotHere)
			self.handles.fig = figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
			self.PlotHere = gca;
		end
		self.handles.dots = scatter(self.PlotHere,NaN,NaN,'filled');

		self.data.values = [];
		self.SamplePoints = [];

		% pick some random points within bounds
		x_space = linspace(self.Lower(1),self.Upper(1),5);
		y_space = linspace(self.Lower(2),self.Upper(2),5);
		z = x_space*0;
		x_rand = x_space(1) + (x_space(end) - x_space(1))*rand(1,2*self.BatchSize);
		y_rand = y_space(1) + (y_space(end) - y_space(1))*rand(1,2*self.BatchSize);
		params = [x_space, x_space, z + x_space(1), z + x_space(end), x_rand; z + y_space(1), z + y_space(end), y_space, y_space, y_rand];

		params = unique(params','rows');

		self.evaluate(params);

		params = self.pickNewPoints;

		self.updatePlot;

		for i = 1:self.MaxIter
			
			self.evaluate(params);

			params = self.pickNewPoints;

			% update graphics
			self.updatePlot;

		end

	end % sample


	function evaluate(self, params)
		values = NaN(size(params,1),1);
		for j = 1:size(params,1)
			values(j) = self.SampleFcn(params(j,:));
		end
		self.data.values = [self.data.values(:); values(:)];
		self.SamplePoints = [self.SamplePoints; params];


	end % evaluate


	function A = scoreTriangles(self, X, Y)


		% find areas of all triangles
		A = zeros(size(self.DT,1),1);


		for i = 1:size(A,1)

			% OK, at least one different

			x1 = X(self.DT.ConnectivityList(i,1));
			x2 = X(self.DT.ConnectivityList(i,2));
			x3 = X(self.DT.ConnectivityList(i,3));
			y1 = Y(self.DT.ConnectivityList(i,1));
			y2 = Y(self.DT.ConnectivityList(i,2));
			y3 = Y(self.DT.ConnectivityList(i,3));

			A(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

		end

		V = abs(max(self.data.values(self.DT.ConnectivityList),[],2) - min(self.data.values(self.DT.ConnectivityList),[],2));

		A = V.*A;




	end % find areas


	function params = pickNewPoints(self)

		X = self.SamplePoints(:,1);
		Y = self.SamplePoints(:,2);
		self.DT = delaunayTriangulation(X,Y);

		S = self.scoreTriangles(X,Y);

		[~,idx] = sort(S,'descend');
		ic = incenter(self.DT);

		idx = idx(1:(self.BatchSize));

		params = ic(idx,:);


	end % pick new points

	function updatePlot(self)
		self.handles.dots.XData = self.SamplePoints(:,1);
		self.handles.dots.YData = self.SamplePoints(:,2);
		self.handles.dots.CData = self.data.values;

		try
			delete(self.handles.DT)
		catch
		end
		self.handles.DT = triplot(self.DT);
		self.handles.DT.Color  = [.5 .5 .5];

		drawnow
	end % update plot

end % methods


methods (Static)



	function test()

		figure('outerposition',[300 300 601 600],'PaperUnits','points','PaperSize',[601 600]); hold on

		[X,Y] = meshgrid(linspace(-1,2,100),linspace(-1,2,100));

		X = X(:); Y = Y(:);

		f = @adaptive.radialFcn;



   		a = adaptive;
   		a.Lower = [-1 -1];
   		a.Upper = [2 2];
   		a.SampleFcn = f;

   		a.PlotHere = gca;

   		a.sample()



	end 


	function f = radialFcn(p)
		x = p(:,1);
		y = p(:,2);

		r  = (2*x).^2 + (y+.1).^2;

		f = r.^2;
		f(r > 1) = f(r > 1).*exp(-r);

	end




end


end % classdef