function addClass(self,~, ~)


if isempty(self.handles.new_class_control.String)
	return
end


self.labels = unique([categorical(NaN); categorical(categories(self.labels)); categorical({self.handles.new_class_control.String})]);


temp = categories(self.labels);
[~,sort_idx]=sort(cellfun(@lower,temp,'UniformOutput',false));
self.handles.CategoryPicker.String = temp(sort_idx);

if ~isempty(self.handles.ReducedData)
	if	any(strcmp({self.handles.ReducedData.Tag},self.handles.new_class_control.String)) 
		return
	end

end
self.handles.ReducedData(end+1) = plot(self.handles.ax(1),NaN,NaN,'.','Tag',self.handles.new_class_control.String,'MarkerSize',20);

self.handles.RawData(end+1) = plot(self.handles.ax(2),NaN,NaN,'Tag',self.handles.new_class_control.String);

if size(self.ColorMap,1) < length(self.handles.ReducedData)
	self.ColorMap = colormaps.dcol(length(self.handles.ReducedData));
end
self.handles.ReducedData(end).Color = self.ColorMap(length(self.handles.ReducedData),:);
self.handles.RawData(end).Color = self.ColorMap(length(self.handles.RawData),:);

self.handles.new_class_control.String = '';