function redrawReducedDataPlot(self,~,~)



cats = categories(self.idx);
for i = 1:length(cats)
	self.handles.ReducedData(i).XData = self.ReducedData(self.idx == cats{i},1);
	self.handles.ReducedData(i).YData = self.ReducedData(self.idx == cats{i},2);
end


% now also plot the raw data
if isempty(self.DisplayFcn)
	% just plot the data and hope for the best


	for i = 1:length(cats)

		plot_this = self.idx == cats{i};
		self.handles.ReducedData(i).MarkerEdgeColor = C(i,:);
		self.handles.ReducedData(i).MarkerFaceColor = C(i,:);
			

		self.handles.RawData(i).XData = 1:size(self.RawData,1);
		self.handles.RawData(i).YData = nanmean(self.RawData(:,plot_this),2);
	end

	set(self.handles.ax(2),'XLim',[1 size(self.RawData,1)],'YLim',[min(self.RawData(:)) max(self.RawData(:))])


else
	if ~isnan(self.CurrentPoint)
		self.DisplayFcn(self.handles.ax(2),self.RawData(self.CurrentPoint,:))
	end
	
end

