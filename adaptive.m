classdef adaptive < ConstructableHandle


properties

	SampleFcn@function_handle
	Lower
	Upper

	MaxIter@double = 40

	MakePlot@logical = true

	BatchSize@double = 36


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

	
		

		self = self@ConstructableHandle(varargin{:});  

		if self.UseParallel && isempty(self.BatchSize)
			pool = gcp;
			self.BatchSize = 2*pool.NumWorkers;
		end


		
	end % constructor


	function sample(self)

		self.Upper = self.Upper(:);
		self.Lower = self.Lower(:);


		% make the figure
		if isempty(self.PlotHere)
			self.handles.fig = figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
			self.PlotHere = gca;
		end
		self.handles.dots = scatter(self.PlotHere,NaN,NaN,'filled');
		self.handles.NaNpts = plot(self.PlotHere,NaN,NaN,'r+');

		self.data.values = [];
		self.SamplePoints = [];

		% pick some random points within bounds
		x_space = linspace(self.Lower(1),self.Upper(1),5);
		y_space = linspace(self.Lower(2),self.Upper(2),5);
		z = x_space*0;
		x_rand = x_space(1) + (x_space(end) - x_space(1))*rand(1,self.BatchSize);
		y_rand = y_space(1) + (y_space(end) - y_space(1))*rand(1,self.BatchSize);
		params = [x_space, x_space, z + x_space(1), z + x_space(end), x_rand; z + y_space(1), z + y_space(end), y_space, y_space, y_rand];

		params = unique(params','rows');

		self.evaluate(params);

		params = self.pickNewPoints;

		self.updatePlot(0);

		for i = 1:self.MaxIter
			
			self.evaluate(params);

			params = self.pickNewPoints;

			% update graphics
			self.updatePlot(i);

		end

	end % sample


	function evaluate(self, params)
		values = NaN(size(params,1),1);

		if self.UseParallel
			parfor j = 1:size(params,1)
				values(j) = self.SampleFcn(params(j,:));
			end
		else
			for j = 1:size(params,1)
				values(j) = self.SampleFcn(params(j,:));
			end
		end
		self.data.values = [self.data.values(:); values(:)];
		self.SamplePoints = [self.SamplePoints; params];


	end % evaluate


	function S = scoreTriangles(self, X, Y)


		% find areas of all triangles
		A = zeros(size(self.DT,1),1);


		for i = 1:size(A,1)


			x1 = X(self.DT.ConnectivityList(i,1));
			x2 = X(self.DT.ConnectivityList(i,2));
			x3 = X(self.DT.ConnectivityList(i,3));
			y1 = Y(self.DT.ConnectivityList(i,1));
			y2 = Y(self.DT.ConnectivityList(i,2));
			y3 = Y(self.DT.ConnectivityList(i,3));

			A(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

		end

		V = abs(max(self.data.values(self.DT.ConnectivityList),[],2) - min(self.data.values(self.DT.ConnectivityList),[],2));

		S = V.*A;


		if all(isnan(S))
			% all values are NaN
			S = rand(length(S),1);
		else
			S(isnan(S)) = 3*min(S(~isnan(S)));
		end






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

	function updatePlot(self, i)
		self.handles.dots.XData = self.SamplePoints(:,1);
		self.handles.dots.YData = self.SamplePoints(:,2);
		self.handles.dots.CData = self.data.values;

		% try
		% 	delete(self.handles.DT)
		% catch
		% end
		% self.handles.DT = triplot(self.DT);
		% self.handles.DT.Color  = [.5 .5 .5];


		plot_this = isnan(self.data.values);
		self.handles.NaNpts.XData = self.SamplePoints(plot_this,1);
		self.handles.NaNpts.YData = self.SamplePoints(plot_this,2);
		drawnow

	end % update plot

end % methods


methods (Static)



	function test()

		close all
		figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on

		subplot(1,2,1); hold on

		[X,Y] = meshgrid(linspace(-1,2,100),linspace(-1,2,100));

		X = X(:); Y = Y(:);

		f = @adaptive.radialFcn;

		Z = f([X,Y]);

		h = scatter(X,Y,'filled');
		h.CData = Z;

		subplot(1,2,2); hold on



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

		r = r(:);
		f = r.^2;
		
		f(r > 1) = f(r > 1).*exp(-r(r>1));

		f(r>4) = NaN;

	end




end


end % classdef