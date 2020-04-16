function makeUI(self)

cats =categories([self.idx; self.labels(:)]);
if isempty(self.ColorMap)
	self.ColorMap = colormaps.dcol(length(cats));
end

% make the UI
self.handles.main_fig = figure('Name','manualCluster','WindowButtonDownFcn',@self.mouseCallback,'NumberTitle','off','position',[50 150 1200 700], 'Toolbar','figure','Menubar','none','CloseRequestFcn',@self.closeManualCluster,'ResizeFcn',@self.resize); hold on,axis off

try getpref('clusterlib','ManualPosition');
	self.handles.main_fig.Position =  getpref('clusterlib','ManualPosition');

catch

end


self.handles.ax(1) = axes('parent',self.handles.main_fig,'position',[-0.1 0.1 0.85 0.85],'box','on','TickDir','out');
axis square, hold on ; 
title('Reduced Data')

self.handles.ax(2) = axes('parent',self.handles.main_fig,'position',[0.6 0.1 0.3 0.3],'box','on','TickDir','out');
axis square, hold on; 
title('Raw data');


self.handles.select_class_control = uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .68 .35 .15],'Style','popupmenu','FontSize',24,'String',categories(self.labels),'Callback',@self.addToCluster);
uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .82 .1 .05],'Style','text','FontSize',24,'String','Add to:','BackgroundColor','w');


if self.AllowNewClasses
	self.handles.new_class_control = uicontrol(self.handles.main_fig,'Units','normalized','position',[.6 .9 .2 .05],'Style','edit','FontSize',24,'String','','BackgroundColor','w');
	uicontrol(self.handles.main_fig,'Units','normalized','position',[.82 .9 .15 .05],'Style','pushbutton','FontSize',24,'String','Add class','Callback',@self.addClass);
end

% make a plot for all the data 
self.handles.AllReducedData = plot(self.handles.ax(1),self.ReducedData(:,1),self.ReducedData(:,2),'.','Color',[.5 .5 .5],'MarkerSize',15);

self.handles.ReducedData = matlab.graphics.GraphicsPlaceholder.empty;
self.handles.RawData = matlab.graphics.GraphicsPlaceholder.empty;

% make a new plot for each of the categories 

for i = 1:length(cats)
	self.handles.ReducedData(i) = plot(self.handles.ax(1),NaN,NaN,'.','MarkerFaceColor',self.ColorMap(i,:),'MarkerEdgeColor',self.ColorMap(i,:),'MarkerSize',20,'Tag',cats{i});
	self.handles.RawData(i) = plot(self.handles.ax(2),NaN,NaN,'MarkerFaceColor',self.ColorMap(i,:),'MarkerEdgeColor',self.ColorMap(i,:),'Tag',cats{i});
end




self.handles.CurrentPointReduced = plot(self.handles.ax(1),NaN,NaN,'+','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',24);
self.handles.CurrentPointRaw = plot(self.handles.ax(2),NaN,NaN,'r-','LineWidth',2);

self.redrawReducedDataPlot();


% make a control that lists all the categories in a listbox
self.handles.CategoryPicker = uicontrol(self.handles.main_fig,'Style','listbox');
self.handles.CategoryPicker.Units = 'normalized';
self.handles.CategoryPicker.Position = [.6 .55 .3 .2];
self.handles.CategoryPicker.Callback = @self.showCategory;
self.handles.CategoryPicker.String = categories(self.labels);
self.handles.CategoryPicker.FontSize = 24;


figlib.pretty('font_units','points');




uistack(self.handles.CurrentPointReduced,'top')
drawnow
