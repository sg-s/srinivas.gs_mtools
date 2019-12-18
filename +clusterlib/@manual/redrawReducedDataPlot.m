function redrawReducedDataPlot(self,~,~)


unique_labels =  unique([self.labels(:); categorical(NaN)]);
C = colormaps.linspecer(length(unique_labels));


% create plots if needed
if length(self.handles.ReducedData) < length(unique_labels)
	for i = length(self.handles.ReducedData)+1:length(unique_labels)
		self.handles.ReducedData(i) = plot(self.handles.ax(1),NaN,NaN,'.','MarkerFaceColor',C(i,:),'MarkerEdgeColor',C(i,:),'MarkerSize',20);
	end
end

if length(self.handles.RawData) < length(unique_labels)
	for i = length(self.handles.RawData)+1:length(unique_labels)
		self.handles.RawData(i) = plot(self.handles.ax(2),NaN,NaN,'MarkerFaceColor',C(i,:),'MarkerEdgeColor',C(i,:),'MarkerSize',20);
	end
end


C = lines;

% populate handles for every class
for i = 1:length(unique_labels)

	if isundefined(unique_labels(i))
		plot_this = isundefined(self.idx);
		self.handles.ReducedData(i).MarkerEdgeColor = [.5 .5 .5];
		self.handles.ReducedData(i).MarkerFaceColor = [.5 .5 .5];
	else
		plot_this = self.idx == unique_labels(i);
		self.handles.ReducedData(i).MarkerEdgeColor = C(i,:);
		self.handles.ReducedData(i).MarkerFaceColor = C(i,:);
		
	end

	self.handles.ReducedData(i).XData = self.ReducedData(plot_this,1);
	self.handles.ReducedData(i).YData = self.ReducedData(plot_this,2);
end


% now also plot the raw data
if isempty(self.DisplayFcn)
	% just plot the data and hope for the best


	for i = 1:length(unique_labels)

		if isundefined(unique_labels(i))
			plot_this = isundefined(self.idx);
			self.handles.RawData(i).MarkerEdgeColor = [.5 .5 .5];
			self.handles.RawData(i).MarkerFaceColor = [.5 .5 .5];
		else
			plot_this = self.idx == unique_labels(i);
			self.handles.ReducedData(i).MarkerEdgeColor = C(i,:);
			self.handles.ReducedData(i).MarkerFaceColor = C(i,:);
			
		end

		self.handles.RawData(i).XData = 1:size(self.RawData,1);
		self.handles.RawData(i).YData = nanmean(self.RawData(:,plot_this),2);
	end

	set(self.handles.ax(2),'XLim',[1 size(self.RawData,1)],'YLim',[min(self.RawData(:)) max(self.RawData(:))])


else
	if ~isnan(self.CurrentPoint)
		self.DisplayFcn(self.handles.ax(2),self.RawData(self.CurrentPoint,:))
	end
	
end

% uistack(self.handles.ReducedData(end),'bottom')
