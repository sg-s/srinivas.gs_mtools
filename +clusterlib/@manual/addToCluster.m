function addToCluster(self, src, ~)

% shim
R = self.ReducedData;



self.DrawingClusters = true;

c = lines;

src_string = get(src,'String');
src_value = get(src,'Value');
this_cluster_name = src_string{src_value};
set(self.handles.main_fig,'Name',['Circle points to add to ' this_cluster_name]);
set(self.handles.main_fig,'Color',c(src_value,:));


ifh = imfreehand(self.handles.ax(1));
p = getPosition(ifh);
inp = inpolygon(R(:,1),R(:,2),p(:,1),p(:,2));


self.idx(inp) = categorical({this_cluster_name});

self.redrawReducedDataPlot;
delete(ifh);
drawnow;


self.DrawingClusters = false;

set(self.handles.main_fig,'Color','w');
set(self.handles.main_fig,'Name',[mat2str(length(find(inp))) ' points added to ' this_cluster_name]);


uiwait(self.handles.main_fig)