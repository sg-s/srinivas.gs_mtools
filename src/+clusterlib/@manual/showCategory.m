function showCategory(self,src,event)

self.handles.AllReducedData.Color = [.8 .8 .8];

show_these = self.idx == categorical(src.String(src.Value));

if isfield(self.handles,'CurrentClass')
	delete(self.handles.CurrentClass)
end

uistack(self.handles.AllReducedData,'top')


uistack(self.handles.ReducedData(find(strcmp({self.handles.ReducedData.Tag},src.String{src.Value}))),'top')
drawnow

self.handles.main_fig.Name = ['This class has ' strlib.oval(sum(show_these)) ' points'];