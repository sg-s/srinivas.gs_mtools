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

	CategoricalResults = false

	XScale = 'linear';
	YScale = 'linear';

	SeedSize = 20;

end


properties (SetAccess = private) 

	% stores the triangulation
	DT@delaunayTriangulation

	SamplePoints
	data
	handles

	boundaries
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


		
		self.PlotHere.XScale = self.XScale;
		self.PlotHere.YScale = self.YScale;


		% determine class of values
		[self.data.values, self.data.results] = self.SampleFcn(self.Lower');
		self.SamplePoints = transpose(self.Lower);
		if iscategorical(self.data.values)
			self.CategoricalResults = true;
		end

		% pick some random points within bounds
		if strcmp(self.XScale,'log')
			x_space = logspace(log10(self.Lower(1)),log10(self.Upper(1)),self.SeedSize);
		else
			x_space = linspace(self.Lower(1),self.Upper(1),self.SeedSize);
		end
		if strcmp(self.YScale,'log')
			y_space = logspace(log10(self.Lower(2)),log10(self.Upper(2)),self.SeedSize);
		else
			y_space = linspace(self.Lower(2),self.Upper(2),self.SeedSize);
		end
		z = x_space*0;
		x_rand = x_space(1) + (x_space(end) - x_space(1))*rand(1,self.SeedSize);
		y_rand = y_space(1) + (y_space(end) - y_space(1))*rand(1,self.SeedSize);
		params = [x_space, x_space, z + x_space(1), z + x_space(end), x_rand; z + y_space(1), z + y_space(end), y_space, y_space, y_rand];

		params = unique(params','rows');

		% remove the probe point we sampled
		params(sum(self.Lower' - params,2) == 0,:) = [];

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

		results = repmat(self.data.results(1),size(params,1),1);

		if self.CategoricalResults
			values = self.data.values(1);
			values = categorical(NaN);
			values = repmat(values,size(params,1),1);
		else
			values = NaN(size(params,1),1);
		end

		if self.UseParallel
			parfor j = 1:size(params,1)
				[values(j), results(j)] = self.SampleFcn(params(j,:));
			end
		else
			for j = 1:size(params,1)
				[values(j), results(j)] = self.SampleFcn(params(j,:));

			end
		end

		self.data.values = [self.data.values(:); values(:)];
		self.data.results = [self.data.results(:); results(:)];
		self.SamplePoints = [self.SamplePoints; params];


	end % evaluate


	function S = scoreTriangles(self)


		% normalize X and Y
		[X,Y] = self.normalize;


		% find areas of all triangles
		A = zeros(size(self.DT,1),1);



		if self.CategoricalResults

			% we score triangles in the categorical case as follows:
			% the sum of every edge length, scaled by a number
			% which is 1 if the nodes are different, and .1 o/w



			S = 0*A;
			for i = 1:size(A,1)

				x1 = X(self.DT.ConnectivityList(i,1));
				x2 = X(self.DT.ConnectivityList(i,2));
				x3 = X(self.DT.ConnectivityList(i,3));
				y1 = Y(self.DT.ConnectivityList(i,1));
				y2 = Y(self.DT.ConnectivityList(i,2));
				y3 = Y(self.DT.ConnectivityList(i,3));

				C = ones(3,1);

				if length(unique(self.data.values(self.DT.ConnectivityList(i,1:2)))) == 1
					C(1) = .1;
				end
				if length(unique(self.data.values(self.DT.ConnectivityList(i,2:3)))) == 1
					C(2) = .1;
				end
				if length(unique(self.data.values(self.DT.ConnectivityList(i,[1 3])))) == 1
					C(3) = .1;
				end

				D = pdist([X(self.DT.ConnectivityList(i,:)) Y(self.DT.ConnectivityList(i,:))]);

				
				S(i) = sum(D(:).*C(:));




			end


		else


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
		end






		if all(isnan(S))
			% all values are NaN
			S = rand(length(S),1);
		else
			S(isnan(S)) = 3*min(S(~isnan(S)));
		end






	end % find areas


	function params = pickNewPoints(self)

		[X,Y] = self.normalize;
		self.DT = delaunayTriangulation(X,Y);

		S = self.scoreTriangles();

		[~,idx] = sort(S,'descend');
		ic = incenter(self.DT);

		idx = idx(1:(self.BatchSize));

		params = ic(idx,:);

		% denormalize
		[params(:,1),params(:,2)] = self.denormalize(params(:,1),params(:,2));



	end % pick new points

	function updatePlot(self,i)
		

		if self.CategoricalResults
			self.handles.dots.XData = self.SamplePoints(:,1);
			self.handles.dots.YData = self.SamplePoints(:,2);
			self.handles.dots.CData = -grp2idx(self.data.values);
		else

			self.handles.dots.XData = self.SamplePoints(:,1);
			self.handles.dots.YData = self.SamplePoints(:,2);
			self.handles.dots.CData = self.data.values;

			plot_this = isnan(self.data.values);
			self.handles.NaNpts.XData = self.SamplePoints(plot_this,1);
			self.handles.NaNpts.YData = self.SamplePoints(plot_this,2);
		end
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


	function [f, dummy] = radialFcn(p)



		x = p(:,1);
		y = p(:,2);

		r  = (2*x).^2 + (y+.1).^2;

		r = r(:);
		f = r.^2;
		
		f(r > 1) = f(r > 1).*exp(-r(r>1));

		f(r>4) = NaN;

		dummy = struct;

	end




end


end % classdef