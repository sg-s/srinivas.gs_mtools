function addClass(self,~, ~)


if isempty(self.handles.new_class_control.String)
	return
end


self.labels = unique([categorical(NaN); categorical(categories(self.labels)); categorical({self.handles.new_class_control.String})]);
self.handles.select_class_control.String = categories(self.labels);

if ~isempty(self.handles.ReducedData)
	if	any(strcmp({self.handles.ReducedData.Tag},self.handles.new_class_control.String)) 
		return
	end

end
self.handles.ReducedData(end+1) = plot(self.handles.ax(1),NaN,NaN,'.','Tag',self.handles.new_class_control.String,'MarkerSize',20);

if size(self.ColorMap,1) < length(self.handles.ReducedData)
	self.ColorMap = colormaps.dcol(length(self.handles.ReducedData));
end
self.handles.ReducedData(end).Color = self.ColorMap(length(self.handles.ReducedData),:);

self.handles.new_class_control.String = '';