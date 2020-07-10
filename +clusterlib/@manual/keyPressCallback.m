function keyPressCallback(self,src,value)

if strcmp(value.Key,'space')
	% add current point to current selcted cat
	this_cluster_name = self.handles.CategoryPicker.String(self.handles.CategoryPicker.Value);
	self.idx(self.CurrentPoint) = categorical(this_cluster_name);

	self.redrawReducedDataPlot;


end