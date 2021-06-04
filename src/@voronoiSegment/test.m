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

