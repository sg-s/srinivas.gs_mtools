classdef dataExplorer < ConstructableHandle


properties
	callback_function@function_handle


	reduced_data

	full_data

	handles

	make_axes@logical = true


	

end


methods

	function self = dataExplorer(varargin)
		self = self@ConstructableHandle(varargin{:});	

		self.handles.ax = matlab.graphics.axis.Axes.empty;
	end



	function makeFigure(self)

		self.handles.main_fig = figure('Name','dataExplorer','WindowButtonDownFcn',@self.mouseCallback,'NumberTitle','off','position',[50 150 1200 700], 'Toolbar','figure','Color','w'); hold on,axis off

		self.handles.menu_name(1) = uimenu('Label','Cluster');
		uimenu(self.handles.menu_name(1),'Label','Add to cluster...','Callback',@clusterlib.interactive);

		if self.make_axes
			self.handles.main_ax(1) = axes('parent',self.handles.main_fig,'position',[-0.1 0.1 0.85 0.85],'box','on','TickDir','out');axis square, hold on ; title('Reduced Data'); hold on

			self.handles.current_point = plot(self.handles.main_ax(1),NaN,NaN,'ro','MarkerSize',10,'MarkerFillColor','r');

			self.handles.ax(2) = axes('parent',self.handles.main_fig,'position',[0.6 0.1 0.3 0.3],'box','on','TickDir','out');axis square, hold on  ; title('Raw data')
		end


	end


	function addMainAx(self,X,Y,E)
		self.handles.main_ax = subplot(X,Y,E); hold on

		if ~isempty(self.reduced_data)
			self.handles.reduced_data = plot(self.reduced_data(:,1),self.reduced_data(:,2),'k.');
		end

		self.handles.current_point = plot(self.handles.main_ax(1),NaN,NaN,'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');
	end

	function addAx(self,X,Y,E)
		self.handles.ax(end+1) = subplot(X,Y,E);
	end


	function mouseCallback(self,~,~)


		pp = get(self.handles.main_ax,'CurrentPoint');
        p(1) = (pp(1,1)); p(2) = pp(1,2);


        x = self.reduced_data(:,1); y = self.reduced_data(:,2);
        [~,cp] = min((x-p(1)).^2+(y-p(2)).^2); % cp C the index of the chosen point
        if length(cp) > 1
            cp = min(cp);
        end


        self.handles.current_point.XData = self.reduced_data(cp,1);
        self.handles.current_point.YData = self.reduced_data(cp,2);

        title(self.handles.main_ax,strlib.oval(cp));

        self.callback_function(self.handles.ax(1),self.full_data(:,cp))



	end


end


end