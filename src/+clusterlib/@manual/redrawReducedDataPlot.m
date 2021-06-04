function redrawReducedDataPlot(self,~,~)


cats = categories(self.idx);

% update reduced data
for i = 1:length(cats)
	this_one = find(strcmp({self.handles.ReducedData.Tag},cats{i}));
	self.handles.ReducedData(this_one).XData = self.ReducedData(self.idx == cats{i},1);
	self.handles.ReducedData(this_one).YData = self.ReducedData(self.idx == cats{i},2);
	self.handles.ReducedData(this_one).MarkerEdgeColor = self.ColorMap(i,:);
	self.handles.ReducedData(this_one).MarkerFaceColor = self.ColorMap(i,:);
end


% now also plot the raw data
if isempty(self.DisplayFcn)
	% just plot the data and hope for the best


	for i = 1:length(cats)
		this_one = find(strcmp({self.handles.RawData.Tag},cats{i}));
		self.handles.RawData(this_one).XData = 1:size(self.RawData,1);
		self.handles.RawData(this_one).YData = mean(self.RawData(:,self.idx==cats{i}),2);
	end

	set(self.handles.ax(2),'XLim',[1 size(self.RawData,1)],'YLim',[min(self.RawData(:)) max(self.RawData(:))])


else
	if ~isnan(self.CurrentPoint)
		self.DisplayFcn(self.handles.ax(2),self.RawData(self.CurrentPoint,:))
	end
	
end

