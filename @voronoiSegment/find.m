
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
		disp('Using provided seed...')
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
	if isempty(N)
		N = length(temp);
	end



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

	[new_x,new_y] = self.deNormalize(new_x,new_y);


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
		fprintf([strlib.fix(strlib.oval(n),10)  ' ' strlib.fix(strlib.oval(mean(A)),10) ' ' strlib.fix(strlib.oval(A_max),10) '\n' ])
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

