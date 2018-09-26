% class that helps you find a border 
% given some objective function 

classdef borderline < handle


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


	% stopping conditions
	min_mesh_size = 1e-6;
	max_fun_eval = 1e4;

	make_plot = true;

end % props


methods 


	function test(self)

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

		return

		% configure
		self.sim_func = @self.test_func;
		self.x_range = [1e-2 1e2];
		self.y_range = [1e-4 1e2];
		self.n_seed = 10;


		self.find();

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

		% make sure the seed has the edges and corners
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
			self.R(i) = self.sim_func(self.x(i),self.y(i));
		end

		n = N;

		if self.make_plot
			figure('outerposition',[300 300 1200 901],'PaperUnits','points','PaperSize',[1200 901]); hold on

			% show this
			handles0 = plot(self.x(self.R==0),self.y(self.R==0),'r.','MarkerSize',24);
			handles1 = plot(self.x(self.R==1),self.y(self.R==1),'b.','MarkerSize',24);

			set(gca,'XLim',self.x_range,'YLim',self.y_range)

			if strcmp(self.x_scale,'log')
				set(gca,'XScale','log')
			end
			if strcmp(self.y_scale,'log')
				set(gca,'YScale','log')
			end

		end
	

		goon = true;

		dlt = plot(NaN,NaN,'k');

		while goon


			% convert to normalized coordinates
			X = self.x(1:n);
			Y = self.y(1:n);
			if strcmp(self.x_scale,'log')
				X = log(X);
				X = X - self.x_range(1);
				X = X/( log(self.x_range(2)) - log(self.x_range(1)));
			else
				X = X - self.x_range(1);
				X = X/(diff(self.x_range));
			end

			if strcmp(self.y_scale,'log')
				Y = log(Y);
				Y = Y - self.y_range(1);
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

				x1 = self.x(DT.ConnectivityList(i,1));
				x2 = self.x(DT.ConnectivityList(i,2));
				x3 = self.x(DT.ConnectivityList(i,3));
				y1 = self.y(DT.ConnectivityList(i,1));
				y2 = self.y(DT.ConnectivityList(i,2));
				y3 = self.y(DT.ConnectivityList(i,3));

				A(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));

			end

			[A_max,idx] = max(A);
			ic = incenter(DT);
			new_x = ic(idx,1);
			new_y = ic(idx,2);


			dlt.XData = repmat(self.x(DT.ConnectivityList(idx,:)),2,1);
			dlt.YData = repmat(self.y(DT.ConnectivityList(idx,:)),2,1);


			if strcmp(self.x_scale,'log')
				new_x = exp((log(self.x_range(2)) - log(self.x_range(1)))*new_x) + self.x_range(1);
			else
				new_x = self.x_range(1) + new_x*diff(self.x_range);
			end

			if strcmp(self.y_scale,'log')
				new_y = exp((log(self.y_range(2)) - log(self.y_range(1)))*new_y) + self.y_range(1);
			else
				new_y = self.y_range(1) + new_y*diff(self.y_range);
			end

			% add it
			n = n + 1;
			self.x(n) = new_x;
			self.y(n) = new_y;

			% evaluate this new point
			self.R(n) = self.sim_func(new_x,new_y);

	
			handles0.XData = self.x(self.R==0);
			handles0.YData = self.y(self.R==0);
			handles1.XData = self.x(self.R==1);
			handles1.YData = self.y(self.R==1);

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

		% need to actually extract the border
		keyboard



	end


end % methods


methods (Static)


	function R = test_linear(x,y)

		R = 0;
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

		R = 1;

	end

	function R = test_log(x,y)

		R = 1;

		if y < 1e-2
			R = 1;
			return
		end

		if x > .5 & x < 2
			R = 1;
			return
		end

		if y > 1/x
			R = 0;
			return
		end

		if y > x
			R = 0;
			return
		end

	end

end


end % end classdef