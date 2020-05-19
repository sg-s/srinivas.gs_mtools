function addToCluster(self, ~, ~)

self.DrawingClusters = true;

% shim
R = self.ReducedData;


this_cluster_name = self.handles.CategoryPicker.String{self.handles.CategoryPicker.Value};


set(self.handles.main_fig,'Name',['Circle points to add to ' this_cluster_name]);


set(self.handles.main_fig,'Color',self.handles.ReducedData(strcmp({self.handles.ReducedData.Tag},this_cluster_name)).Color);


ifh = imfreehand(self.handles.ax(1));
p = getPosition(ifh);
inp = inpolygon(R(:,1),R(:,2),p(:,1),p(:,2));


self.idx(inp) = categorical({this_cluster_name});

self.redrawReducedDataPlot;
delete(ifh);



set(self.handles.main_fig,'Color','w');
set(self.handles.main_fig,'Name',[mat2str(length(find(inp))) ' points added to ' this_cluster_name '. ' mat2str(100*mean(~isundefined(self.idx)),2) '% of points have been labeled']);



self.DrawingClusters = false;
self.handles.add_to_class_toggle.Value = false;

drawnow;
