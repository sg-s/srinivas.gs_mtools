
function traceBoundaries(self,R, n_classes)

if strcmp(self.XScale,'log')
	error('Not coded')
	all_x = logspace(log10(self.Lower(1)),log10(self.Upper(1)),1e3);
else
	all_x = linspace(self.Lower(1),self.Upper(1),1e3);
end
if strcmp(self.YScale,'log')
	error('Not coded')
	all_y = logspace(log10(self.Lower(2)),log10(self.Upper(2)),1e3);
else
	all_y = linspace(self.Lower(2),self.Upper(2),1e3);
end



% ok, we now have a labeled, rasterized image
% find the boundaries of each class of data
for i = 1:n_classes

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