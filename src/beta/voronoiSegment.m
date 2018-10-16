% voronoiSegment
% class that helps draw borders between
% regions in 2D space given some 
% function that returns discrete values
% when given an argument from the plane 
%
% usage:
% see voronoiSegment.test()

classdef voronoiSegment < handle


properties

	sim_func@function_handle
	x_range 
	y_range 
	n_seed@double

	x_scale = 'log'
	y_scale = 'log'


	x
	y
	R

	boundaries

	n_classes = 2


	labels@cell

	% stopping conditions
	min_mesh_size = 1e-6;
	max_fun_eval = 1e4;
	mean_mesh_size = 2e-5;

	make_plot = false;
	segment_regions = true;
	Display = 'iter'


	% you can use this to store anything you 
	% want. this will be sent to the function
	% 
	data

	% additional results returned by
	% objective function for post-hoc
	% analysis 
	results@Data
	handles


	% stores the triangulation
	DT@delaunayTriangulation

end % props


methods 


	function test(self,show_this)

		self.make_plot = true;

		if nargin < 2
			show_this = {'log-funnel','linear-island'};
		end

		% test the log case
		if any(strcmp(show_this,'log-funnel'))
			self.sim_func = @self.test_log;
			self.x_range = [1e-2 1e2];
			self.y_range = [1e-4 1e2];
			self.n_classes = 3;
			self.n_seed = 5;
			self.max_fun_eval = 200;
			self.x_scale = 'log';
			self.y_scale = 'log';
			self.find();

			self.findBoundaries(self.handles.ax(2))

			drawnow
			pause(5)
			close all
			self.x = [];
			self.y = [];
			self.R = [];
		end


		% test the linear case
		if any(strcmp(show_this,'linear-island'))
			self.n_classes = 2;
			self.sim_func = @self.test_linear;
			self.x_range = [0 1];
			self.y_range = [0 1];
			self.n_seed = 10;
			self.x_scale = 'linear';
			self.y_scale = 'linear';
			x = rand(10,1);
			y = rand(10,1);
			x(1) = .5; y(1) = .5;
			self.find(x,y);
			self.findBoundaries(self.handles.ax(2))
			drawnow
			pause(5)
			close all



		end

		


	end



	function [X,Y] = normalize(self)
		% convert to normalized coordinates
		n = find(~isnan(self.x),1,'last');
		X = self.x(1:n);
		Y = self.y(1:n);
		if strcmp(self.x_scale,'log')
			X = log(X) - log(self.x_range(1));
			X = X/( log(self.x_range(2)) - log(self.x_range(1)));
		else
			X = X - self.x_range(1);
			X = X/(diff(self.x_range));
		end

		if strcmp(self.y_scale,'log')
			Y = log(Y) - log(self.y_range(1));
			Y = Y/( log(self.y_range(2)) - log(self.y_range(1)));
		else
			Y = Y - self.y_range(1);
			Y = Y/(diff(self.y_range));
		end
	end


	function A = findAreas(self,X,Y)
		DT = self.DT;
		% find areas of all triangles
		A = zeros(size(DT,1),1);
		for i = 1:size(A,1)
			% only if the vertices are different 
			if min(self.R(DT.ConnectivityList(i,:))) == max(self.R(DT.ConnectivityList(i,:)))
				continue
			end

			% OK, at least one different

			x1 = X(DT.ConnectivityList(i,1));
			x2 = X(DT.ConnectivityList(i,2));
			x3 = X(DT.ConnectivityList(i,3));
			y1 = Y(DT.ConnectivityList(i,1));
			y2 = Y(DT.ConnectivityList(i,2));
			y3 = Y(DT.ConnectivityList(i,3));

			A(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

		end
	end


	function find(self, seed_x, seed_y)

		if self.make_plot
			self.handles.fig = figure('outerposition',[300 300 1000 502],'PaperUnits','points','PaperSize',[1000 502]); hold on
			clear ax
			ax(1) = subplot(1,2,1); hold on
			ax(2) = subplot(1,2,2); hold on
			title(ax(1),'Samples')
			title(ax(2),'Segmented space')

			% create placeholders for all classes
			c = parula(self.n_classes);
			for i = 1:self.n_classes
				handles(i) = plot(ax(1),NaN,NaN,'.','MarkerSize',24,'MarkerFaceColor',c(i,:));

				phandles(i) = plot(ax(2),polyshape());
			end
			for i = 1:self.n_classes
				handles(i).XData = self.x(self.R == i);
				handles(i).YData = self.y(self.R == i);
			end
			if ~isempty(self.labels)
				legend(handles,self.labels,'Location','northwestoutside')
			end

			set(ax(1),'XLim',self.x_range,'YLim',self.y_range)
			set(ax(2),'XLim',self.x_range,'YLim',self.y_range)

			if strcmp(self.x_scale,'log')
				set(ax(1),'XScale','log')
				set(ax(2),'XScale','log')
			end
			if strcmp(self.y_scale,'log')
				set(ax(1),'YScale','log')
				set(ax(2),'YScale','log')
			end

			self.handles.ax = ax;
		end
	


		if isempty(self.x)
			self.x = NaN(self.max_fun_eval,1);
			self.y = NaN(self.max_fun_eval,1);
			self.R = NaN(self.max_fun_eval,1);


			if strcmp(self.x_scale,'log')
				xgrid = logspace(log10(self.x_range(1)),log10(self.x_range(2)),10);
			else
				xgrid = linspace(self.x_range(1),self.x_range(2),10);
			end

			if strcmp(self.y_scale,'log')
				ygrid = logspace(log10(self.y_range(1)),log10(self.y_range(2)),10);
			else
				ygrid = linspace(self.y_range(1),self.y_range(2),10);
			end


			% start with a seed if none provided 
			if nargin == 3
				N = length(seed_x);
				self.x(1:N) = seed_x;
				self.y(1:N) = seed_y;


			else
				assert(~isempty(self.n_seed),'n_seed not defined')
				N = self.n_seed;
				if strcmp(self.x_scale,'log')
					
					self.x(1:N) = exp(log(self.x_range(1)) + diff(log(self.x_range))*rand(N,1));

				else
					
					self.x(1:N) = rand(N,1)*diff(self.x_range) + self.x_range(1);
				end
				if strcmp(self.y_scale,'log')
					self.y(1:N) = exp(log(self.y_range(1)) + diff(log(self.y_range))*rand(N,1));
				else
		
					self.y(1:N) = rand(N,1)*diff(self.y_range) + self.y_range(1);
				end
			end

			% make sure the seed has all the corners
			% and has lots of points on all the 
			% edges

			gridx = [xgrid xgrid xgrid*0 + xgrid(1) xgrid*0 + xgrid(end)];
			gridy = [ygrid*0 + ygrid(1) ygrid*0 + ygrid(end) ygrid ygrid];
			self.x(N+1:N+length(gridx)) = gridx;
			self.y(N+1:N+length(gridy)) = gridy;

			temp = [self.x, self.y];
			temp = unique(temp,'rows');
			self.x = temp(:,1);
			self.y = temp(:,2);


			N = find(isnan(temp(:,1)),1,'first') - 1;



			% evaluate function here 
			[self.R(1), self.results] = self.sim_func(self.x(1),self.y(1),self.data);

			for i = 2:N
				[self.R(i), results] = self.sim_func(self.x(i),self.y(i),self.data);
				self.results + results;

				% update plots
				for j = 1:self.n_classes
					handles(j).XData = self.x(self.R==j);
					handles(j).YData = self.y(self.R==j);
				end
				drawnow

			end

			n = N;

		else
			n = find(~isnan(self.x),1,'last');

		end



		if strcmp(self.x_scale,'log')
			logx = true;
		else
			logx = false;
		end

		if strcmp(self.y_scale,'log')
			logy = true;
		else
			logy = false;
		end


		goon = true;

		if strcmp(self.Display,'iter')
			fprintf('N        Mean Mesh Size    Min Mesh Size\n')
			fprintf('----------------------------------------\n')
		end

		while goon


			[X,Y] = self.normalize;

			% find the delaunay triangulation of these points
			self.DT = delaunayTriangulation(X,Y);

			A = self.findAreas(X,Y);

			[A_max,idx] = max(A);
			ic = incenter(self.DT);
			new_x = ic(idx,1);
			new_y = ic(idx,2);

			if strcmp(self.x_scale,'log')

				new_x = exp(new_x*(log(self.x_range(2)) - log(self.x_range(1))) + log(self.x_range(1)));
			else
				new_x = self.x_range(1) + new_x*diff(self.x_range);
			end

			if strcmp(self.y_scale,'log')
				new_y = exp(new_y*(log(self.y_range(2)) - log(self.y_range(1))) + log(self.y_range(1)));
			else
				new_y = self.y_range(1) + new_y*diff(self.y_range);
			end

			assert(new_y >= self.y_range(1) & new_y <= self.y_range(2),'247')
			assert(new_x >= self.x_range(1) & new_x <= self.x_range(2),'247')

			% add it
			n = n + 1;
			self.x(n) = new_x;
			self.y(n) = new_y;

			% evaluate this new point
			[self.R(n), results] = self.sim_func(new_x,new_y,self.data);
			self.results + results;


			if strcmp(self.Display,'iter')
				fprintf([flstring(oval(n),10)  ' ' flstring(oval(mean(A)),10) ' ' flstring(oval(A_max),10) '\n' ])
			end
	
			% update plots
			for i = 1:self.n_classes
				handles(i).XData = self.x(self.R==i);
				handles(i).YData = self.y(self.R==i);
			end



			if mean(A) < self.mean_mesh_size
				disp('Stopping because mean mesh size was reached')
				goon = false;
			end

			if A_max < self.min_mesh_size
				disp('Stopping because minimum mesh size was reached')
				goon = false;
			end

			if n > self.max_fun_eval
				disp('Stopping because max_fun_eval was reached')
				goon = false;
			end

			drawnow
		
		end % while

		

	end



	function findBoundaries(self, make_plot)


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

		% only if the vertices are different 
		DT = self.DT;
		for i = 1:size(DT,1)
			if min(self.R(DT.ConnectivityList(i,:))) == max(self.R(DT.ConnectivityList(i,:)))
				
				% OK, all the same
				inp = inpolygon(all_x,all_y,X(DT.ConnectivityList(i,:)),Y(DT.ConnectivityList(i,:)));
				R(inp) = min(self.R(DT.ConnectivityList(i,:)));



			end
		end

		% fill in NaNs using nerest neighbours
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


		% ok, we now have a labelled, rasterized image
		% find the boundaries of each class of data
		for i = 1:self.n_classes

			this_R = (R==i);

			% check if there are mulitple connected components
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



		if isa(make_plot,'matlab.graphics.axis.Axes')
			plot_here =  make_plot;
		elseif islogical(make_plot)
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

		




	end % find boundaries




end % methods


methods (Static)


	function [R, D] = test_linear(x,y,~)

		R = 1;
		D = Data;
		if x < .3
			return
		end
		if x > .6
			return
		end

		if y < x
			return
		end

		if y > x + .1
			return
		end

		R = 2;
		

	end

	function [R, D] = test_log(x,y,~)

		R = 1;
		D = Data;

		if y < 1e-2
			return
		end

		if x > .5 & x < 2
			return
		end

		if y > 1/x & x > .5
			R = 2;
			return
		end

		if y > x
			R = 3;
			return
		end

	end

end


end % end classdef