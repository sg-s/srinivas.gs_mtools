function showCategory(self,src,event)

show_these = self.idx == categorical(src.String(src.Value));

if isfield(self.handles,'CurrentClass')
	delete(self.handles.CurrentClass)
end

XY =  self.ReducedData(show_these,:);

self.handles.CurrentClass = plot(self.handles.ax(1),XY(:,1),XY(:,2),'o','Color',[.8 .8 .8],'MarkerSize',12,'MarkerFaceColor',[.8 .8 .8]);
uistack(self.handles.CurrentClass,'bottom')
drawnow

self.handles.main_fig.Name = ['This class has ' strlib.oval(sum(show_these)) ' points'];