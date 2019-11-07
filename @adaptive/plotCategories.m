% plots categories using a triangulation-based plot

function patch_handle = plotCategories(self, plot_here)

if nargin == 1
	figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
	plot_here = gca;
end


[X,Y] = self.normalize;
DT = delaunayTriangulation([X,Y]);

F = -grp2idx(mode(self.data.values(DT.ConnectivityList),2));

[X,Y] = self.denormalize(DT.Points(:,1),DT.Points(:,2));

patch_handle = patch(plot_here,'Faces',DT.ConnectivityList,'Vertices',[X,Y],'FaceVertexCData',F,'FaceColor','flat');

patch_handle.EdgeAlpha = .02;