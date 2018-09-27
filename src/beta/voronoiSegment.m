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

	n_classes = 2


	labels@cell

	% stopping conditions
	min_mesh_size = 1e-6;
	max_fun_eval = 1e4;
	mean_mesh_size = 2e-5;

	make_plot = false;


	% you can use this to store anything you 
	% want. this will be sent to the function
	% 
	data

end % props


methods 


	function test(self)

		self.make_plot = true;

				% test the log case
		self.sim_func = @self.test_log;
		self.x_range = [1e-2 1e2];
		self.y_range = [1e-4 1e2];
		self.n_classes = 3;
		self.n_seed = 5;
		self.x_scale = 'log';
		self.y_scale = 'log';
		self.find();
		close all


		% test the linear case
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
		close all



		


	end


	function find(self, seed_x, seed_y)
		self.x = NaN(self.max_fun_eval,1);
		self.y = NaN(self.max_fun_eval,1);
		self.R = NaN(self.max_fun_eval,1);



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
		edge_x(1) = self.x_range(1);
		edge_y(1) = self.y_range(1);

		edge_x(2) = self.x_range(2);
		edge_y(2) = self.y_range(1);

		edge_x(3) = self.x_range(2);
		edge_y(3) = self.y_range(2);

		edge_x(4) = self.x_range(1);
		edge_y(4) = self.y_range(2);

		self.x(N+1:N+4) = edge_x(:);
		self.y(N+1:N+4) = edge_y(:);

		N = N + 4;



		% evaluate function here 
		for i = 1:N
			self.R(i) = self.sim_func(self.x(i),self.y(i),self.data);
		end

		n = N;

		if self.make_plot
			figure('outerposition',[300 300 1200 601],'PaperUnits','points','PaperSize',[1200 601]); hold on
			clear ax
			ax(1) = subplot(1,2,1); hold on
			ax(2) = subplot(1,2,2); hold on
			title(ax(1),'Real space')
			title(ax(2),'Coordinate space')

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
				legend(handles,self.labels)
			end

			set(ax(1),'XLim',self.x_range,'YLim',self.y_range)
			set(ax(2),'XLim',self.x_range,'YLim',self.y_range)

			bline = plot(ax(2),NaN,NaN,'k-','LineWidth',4);

			if strcmp(self.x_scale,'log')
				set(ax(1),'XScale','log')
				set(ax(2),'XScale','log')
			end
			if strcmp(self.y_scale,'log')
				set(ax(1),'YScale','log')
				set(ax(2),'YScale','log')
			end

		end
	

		goon = true;
		warning('off','MATLAB:polyshape:repairedBySimplify')

		while goon


			% convert to normalized coordinates
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

			% find the delaunay triangulation of these points
			DT = delaunayTriangulation(X,Y);

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

			[A_max,idx] = max(A);
			ic = incenter(DT);
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
			self.R(n) = self.sim_func(new_x,new_y,self.data);

	
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

			% draw a boundary line


			% now for each class of points, find the boundary
			E = edges(DT);
			L = Inf(length(E),1);
			for i = 1:length(E)
				if diff(self.R(E(i,:))) == 0
					continue
				end
				L(i) = (X(E(i,1)) - X(E(i,2)))^2 + (Y(E(i,1)) - Y(E(i,2)))^2;
			end
			L = sqrt(L);




			for i = 1:self.n_classes
				% find all the edges where at least one 
				% vertex is i
				
				region_edges = self.R(E(:,1)) == i | self.R(E(:,2)) == i;

				look_at_these = L < .1 & region_edges;
				if sum(look_at_these) > 5
					
					temp_X = mean(self.x(E(look_at_these,:)),2);
					temp_Y = mean(self.y(E(look_at_these,:)),2);

					% add to this all points in this region
					% that are on the boundary

					this_x = self.x(self.R == i);
					this_y = self.y(self.R == i);

					keep = this_x == self.x_range(2) | this_x == self.x_range(1) | this_y == self.y_range(2) | this_y == self.y_range(1);
					temp_X = [temp_X; this_x(keep)];
					temp_Y = [temp_Y; this_y(keep)];

					[temp_X, temp_Y] = thread.unravel(temp_X,temp_Y);

					
					phandles(i).Shape = (polyshape(temp_X,temp_Y,'Simplify',true));
					

				end

			end


	
			drawnow
		
		end % while
		warning('on','MATLAB:polyshape:repairedBySimplify')



	end


end % methods


methods (Static)


	function R = test_linear(x,y,~)

		R = 1;
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

	function R = test_log(x,y,~)

		R = 1;

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