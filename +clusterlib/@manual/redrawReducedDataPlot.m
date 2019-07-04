function redrawReducedDataPlot(self,~,~)

unique_labels =  unique(self.labels);

% create plots if needed
if length(self.handles.ReducedData) < length(unique_labels)
	for i = length(self.handles.ReducedData)+1:length(unique_labels)
		self.handles.ReducedData(i) = plot(self.handles.ax(1),NaN,NaN,'.');
	end
end

if length(self.handles.RawData) < length(unique_labels)
	for i = length(self.handles.RawData)+1:length(unique_labels)
		self.handles.RawData(i) = plot(self.handles.ax(2),NaN,NaN);
	end
end




% populate handles for every class

for i = 1:length(unique_labels)

	plot_this = self.idx == unique_labels(i);
	self.handles.ReducedData(i).XData = self.ReducedData(plot_this,1);
	self.handles.ReducedData(i).YData = self.ReducedData(plot_this,2);

	if unique_labels(i) == categorical({'Undefined'})
		self.handles.ReducedData(i).Color = [.5 .5 .5];
	end

end




% now also plot the raw data
if isempty(self.DisplayFcn)
	% just plot the data and hope for the best


	% first plot the unsorted data
	plot_this = self.idx == categorical({'Undefined'});
	plot_idx = find(unique_labels == categorical({'Undefined'}));

	self.handles.RawData(plot_idx).XData = 1:size(self.RawData,1);
	self.handles.RawData(plot_idx).YData = mean(self.RawData,2);

	self.handles.RawData(plot_idx).Color = [.5 .5 .5];




else
	keyboard
end