function makeUI(self)

% make the UI
self.handles.main_fig = figure('Name','manualCluster','WindowButtonDownFcn',@self.mouseCallback,'NumberTitle','off','position',[50 150 1200 700], 'Toolbar','figure','Menubar','none','CloseRequestFcn',@self.closeManualCluster); hold on,axis off


self.handles.ax(1) = axes('parent',self.handles.main_fig,'position',[-0.1 0.1 0.85 0.85],'box','on','TickDir','out');
axis square, hold on ; 
title('Reduced Data')

self.handles.ax(2) = axes('parent',self.handles.main_fig,'position',[0.6 0.1 0.3 0.3],'box','on','TickDir','out');
axis square, hold on; 
title('Raw data');


self.handles.select_class_control = uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .50 .35 .15],'Style','popupmenu','FontSize',24,'String',categories(self.labels),'Callback',@self.addToCluster);
uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .65 .1 .05],'Style','text','FontSize',24,'String','Add to:','BackgroundColor','w');


if self.AllowNewClasses
	self.handles.new_class_control = uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .8 .2 .05],'Style','edit','FontSize',24,'String','','BackgroundColor','w');
	uicontrol(self.handles.main_fig,'Units','normalized','position',[.82 .8 .15 .05],'Style','pushbutton','FontSize',24,'String','Add class','Callback',@self.addClass);
end

self.handles.ReducedData = matlab.graphics.GraphicsPlaceholder.empty;
self.handles.RawData = matlab.graphics.GraphicsPlaceholder.empty;
self.handles.CurrentPointReduced = plot(self.handles.ax(1),NaN,NaN,'o','MarkerFaceColor','r','MarkerEdgeColor','r');
self.handles.CurrentPointRaw = plot(self.handles.ax(2),NaN,NaN,'r-','LineWidth',2);

self.redrawReducedDataPlot();

figlib.pretty('font_units','points');

uistack(self.handles.CurrentPointReduced,'top')
