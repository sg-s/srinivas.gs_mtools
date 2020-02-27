function addClass(self,~, ~)

self.labels = [categorical(NaN); categorical(categories(self.labels)); categorical({self.handles.new_class_control.String})];
self.handles.select_class_control.String = categories(self.labels);


self.redrawReducedDataPlot;