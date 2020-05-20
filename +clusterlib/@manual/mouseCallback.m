function mouseCallback(self, src, ~)


if (self.handles.add_to_class_toggle.Value)
    if self.DrawingClusters
	   return
    else
        self.addToCluster;
    end
end

R = self.ReducedData;


pp = get(self.handles.ax(1),'CurrentPoint');
p(1) = (pp(1,1)); p(2) = pp(1,2);


x = R(:,1); y = R(:,2);
[~,cp] = min((x-p(1)).^2+(y-p(2)).^2); % cp C the index of the chosen point
if length(cp) > 1
    cp = min(cp);
end

self.CurrentPoint = cp;



if ~isempty(self.idx)
    self.handles.main_fig.Name = ['This point ('  mat2str(cp)   ') has been assigned to class: ' char(self.idx(cp))];
end


self.handles.CurrentPointReduced.XData = self.ReducedData(cp,1);
self.handles.CurrentPointReduced.YData = self.ReducedData(cp,2);


% show the clicked point
if isempty(self.DisplayFcn)

	% using simple plot


	if gca == self.handles.ax(1)


        

        self.handles.CurrentPointRaw.XData = 1:length(self.RawData(:,cp));
        self.handles.CurrentPointRaw.YData = self.RawData(:,cp);


        set(self.handles.ax(2),'XLim',[1 size(self.RawData,1)],'YLim',[min(self.RawData(:,cp)) max(self.RawData(:,cp))])

   	end


else
	if ~isnan(self.CurrentPoint)
        self.DisplayFcn(self.handles.ax(2),self.RawData(self.CurrentPoint,:))
    end
end



if ~isempty(self.MouseCallbackFcn)
    self.MouseCallbackFcn(self)
end

uistack(self.handles.CurrentPointReduced,'top')
drawnow
