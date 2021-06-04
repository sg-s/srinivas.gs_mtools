
function traceBoundaries(self,R)

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



% ok, we now have a labeled, rasterized image
% find the boundaries of each class of data
for i = 1:self.n_classes

	this_R = (R==i);

	% check if there are multiple connected components
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