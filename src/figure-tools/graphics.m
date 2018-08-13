% designFig.m
% interactively design a figure with multiple subplots and get designFig to make the code for you

classdef graphics < handle

properties

	grid_spacing = 10; % px

	% initialise variables
	allrect = struct('h',{});

	rect_positions

	widths = struct('x_label',{},'y_label',{},'x_ticks',{},'y_ticks',{});
	

	x_label_width = 20;
	y_label_width = 20;
	x_ticks_width = 20;
	y_ticks_width = 20;

	paper_size = [8.5 11];
	paper_units = 'inches';

	show_guides@logical = true

end

properties (SetAccess = protected)
	screen_size = get(0,'ScreenSize');
	handles
end 


methods 


	function self = graphics(gfx_file_name)

		if nargin == 1

			m = matfile(gfx_file_name);

			props = properties(m);
			for i = 1:length(props)
				if strcmp(props{i},'Properties')
					continue
				end
				self.(props{i}) = m.(props{i});
			end
		end
	end

	function design(self)

		screen_size = self.screen_size;
		paper_size = self.paper_size;
		

		handles.fig = figure('Toolbar','none','Menubar','none','Name','Figure Designer','NumberTitle','off','Units','points','Position',[0 0 round(((screen_size(4)*.9)/paper_size(2))*paper_size(1)) screen_size(4)*.9],'PaperUnits','inches','PaperSize',[paper_size],'Color','w','Resize','off'); hold on


		self.grid_spacing = round(handles.fig.Position(4)/10);

		handles.main_ax = gca;

		figure_position = handles.fig.Position;

		set(handles.main_ax,'Position',[0 0 1 .95],'box','on','XLim',[0 figure_position(3)],'YLim',[0 figure_position(4)],'YMinorGrid','on','XMinorGrid','on','XTick',[0:self.grid_spacing:figure_position(3)],'YTick',[0:self.grid_spacing:figure_position(4)]);

		handles.AddSubplotControl = uicontrol(handles.fig,'Units','normalized','Position',[.01 .96 .1 .03],'Style','pushbutton','Enable','on','String','Add plot','FontSize',10,'Callback',@self.addRect);


		handles.ToggleGridControl = uicontrol(handles.fig,'Units','normalized','Position',[.13 .96 .1 .03],'Style','pushbutton','Enable','on','String','Toggle Grid','FontSize',10,'Callback',@self.toggleGrid);

		% buttons to make the grid smaller or bigger
		uicontrol(handles.fig,'Units','normalized','Position',[.23 .96 .04 .03],'Style','pushbutton','Enable','on','String','+','FontSize',15,'Callback',@self.resizeGrid);
		uicontrol(handles.fig,'Units','normalized','Position',[.27 .96 .04 .03],'Style','pushbutton','Enable','on','String','-','FontSize',15,'Callback',@self.resizeGrid);

		handles.SnapControl = uicontrol(handles.fig,'Units','normalized','Position',[.4 .96 .1 .03],'Style','pushbutton','Enable','on','String','Snap','FontSize',10,'Callback',@self.snap);

		handles.PositionDisplay = uicontrol(handles.fig,'Units','normalized','Position',[.55 .96 .1 .03],'Style','text','Enable','on','String','','FontSize',10);



		self.handles = handles;

		% make the rectangles
		for i = 1:length(self.allrect)
			self.allrect(i).h = imrect(self.handles.main_ax,self.rect_positions(:,i)');
			addNewPositionCallback(self.allrect(i).h,@self.updatePositionDisplay);

		end

		self.redrawLabels();


	end % design

	function addRect(self,~,~)
		nplots = length(self.allrect) + 1;
		self.allrect(nplots).h = imrect;
		addNewPositionCallback(self.allrect(nplots).h,@self.updatePositionDisplay);

		self.rect_positions(:,nplots) = getPosition(self.allrect(nplots).h);

		self.widths(nplots).x_label = self.x_label_width;
		self.widths(nplots).x_ticks = self.x_ticks_width;
		self.widths(nplots).y_label = self.y_label_width;
		self.widths(nplots).y_ticks = self.y_ticks_width;

	end % addRect


	function updatePositionDisplay(self,src,~)
		set(self.handles.PositionDisplay,'String',mat2str(round(src)));
		% redraw all labels. this is a hack because i don't know how to find the rectangle that is being resized
		self.redrawLabels;

		% update positions of all rectangles
		for i = 1:length(self.allrect)
			self.rect_positions(:,i) = getPosition(self.allrect(i).h);
		end


	end

	function redrawLabels(self,~,~)

		if isfield(self.handles,'text_handles')
			for i = 1:length(self.handles.text_handles)
				delete(self.handles.text_handles(i))
			end
		end
		for i = 1:length(self.allrect)
			this_rect = self.allrect(i);
			p = getPosition(this_rect.h);
			
			self.handles.text_handles(i) =  text(p(1) + p(3)/2,p(2) + p(4)/2,mat2str(i),'FontSize',48);
		end
	end % RedrawLabels


	function snap(self,~,~)

		for i = 1:length(self.allrect)
			this_pos = getPosition(self.allrect(i).h);
			setPosition(self.allrect(i).h,round(this_pos/(self.grid_spacing/5))*(self.grid_spacing/5));
		end
	end



	function resizeGrid(self,src,value)

		figure_position = self.handles.fig.Position;

		if strcmp(src.String,'+')
			self.grid_spacing = self.grid_spacing + 2;
		else
			self.grid_spacing = self.grid_spacing - 2;
		end
		if self.grid_spacing < 10
			self.grid_spacing = 10;
		end
		set(self.handles.main_ax,'XTick',[0:self.grid_spacing:figure_position(3)],'YTick',[0:self.grid_spacing:figure_position(4)])


	end % resizeGrid


	function toggleGrid(self,~,~)
		if strcmp(get(self.handles.main_ax,'YMinorGrid'),'off')
			set(self.handles.main_ax,'YMinorGrid','on','XMinorGrid','on')
		else
			set(self.handles.main_ax,'YMinorGrid','off','XMinorGrid','off')
		end
	end % toggleGrid



	function save(self,name)
		assert(nargin == 2,'No name')
		
		props = properties(self);
		m = matfile([name '.gfx'],'Writable',true);


		for i = 1:length(props)
			if strcmp(props{i},'handles')
				continue
			end
			m.(props{i}) = self.(props{i});
		end

		
	end

	function handles = generateFigure(self)

		screen_size = self.screen_size;
		paper_size = self.paper_size;

		% make figure 
		handles.fig = figure('NumberTitle','off','Units','points','Position',[0 0 round(((screen_size(4)*.9)/paper_size(2))*paper_size(1)) screen_size(4)*.9],'PaperUnits','inches','PaperSize',[paper_size],'Color','w','Resize','off'); hold on
		
		% resize the base ax
		handles.base_ax = gca;
		handles.base_ax.Units = 'points';

		handles.base_ax.Position = [0 0 round(((screen_size(4)*.9)/paper_size(2))*paper_size(1)) screen_size(4)*.9];
		handles.base_ax.YLim = [0 screen_size(4)*.9];
		handles.base_ax.XLim = [0 round(((screen_size(4)*.9)/paper_size(2))*paper_size(1))];


		if self.show_guides

			% draw rectangles indicating where the axes should be
			for i = 1:length(self.allrect)
				rectangle(handles.base_ax,'Position',self.rect_positions(:,i),'EdgeColor','r');
			end
		end

		% make all the axes
		for i = length(self.allrect):-1:1

			x_offset =  self.widths(i).x_label + self.widths(i).x_ticks;
			y_offset =  self.widths(i).y_label + self.widths(i).y_ticks;
	

			inner_pos = self.rect_positions(:,i);
			inner_pos(1) = inner_pos(1) + x_offset;
			inner_pos(2) = inner_pos(2) + y_offset;
			inner_pos(3) = inner_pos(3) - x_offset;
			inner_pos(4) = inner_pos(4) - y_offset;

			handles.ax(i) = axes('Units','points','Position',inner_pos,'DataAspectRatioMode','auto','PlotBoxAspectRatioMode','auto','PlotBoxAspectRatioMode','auto','ActivePositionProperty','Position','Box','on');


		end



	end % makes a figure 


end % methods



end % end classdef 









