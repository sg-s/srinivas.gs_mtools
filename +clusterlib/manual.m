% Manually cluster 2D data
% manualCluster
% creates a GUI to manually cluster 1D or 2D data into clusters
% the number of the clusters and the labels are defined in labels, which is a cell array
% 
% usage:
% idx = manualCluster(R,X,labels);
% 
% where
% R is a 2 x N matrix or a 1 x D vector 
% X is a D x N matrix, which is the non-reduced data 
% labels is a cell array what is M elements long, where you want to cluster into M clusters
% idx is a vector N elements long
% 
% in addition, you can also two more arguments:
% idx = manualCluster(R,X,labels,runOnClick)
% where runOnClick is a function handle that manualCluster will attempt to run as follows:
% runOnClick(idx)
% 
% created by Srinivas Gorur-Shandilya 
% Contact me at http://srinivas.gs/contact/
% 

function [idx, labels] = manual(R,X,labels,runOnClick)

if ~nargin
    help clusterlib.manual
    return
end

% orient data correctly 
if ~isvector(R)

else
    R = R(:);
    R = [R randn(length(R),1)];
    R = R';
end


assert(length(R) == size(X,2),'reduced and full data should be of equal lengths')
assert(iscell(labels),'Labels should be cell array')

idx = zeros(1,length(R)); % stores the cluster ID

% make a colour scheme
if length(labels) < 5
    c = lines(length(labels));
else
    c = parula(length(labels) + 1);
end

% make the UI
handles.main_fig = figure('Name','manualCluster','WindowButtonDownFcn',@mouseCallback,'NumberTitle','off','position',[50 150 1200 700], 'Toolbar','figure','Menubar','none','CloseRequestFcn',@closeManualCluster); hold on,axis off
handles.ax(1) = axes('parent',handles.main_fig,'position',[-0.1 0.1 0.85 0.85],'box','on','TickDir','out');axis square, hold on ; title('Reduced Data')
handles.ax(2) = axes('parent',handles.main_fig,'position',[0.6 0.1 0.3 0.3],'box','on','TickDir','out');axis square, hold on  ; title('Raw data'), set(gca,'YLim',[min(min(R)) max(max(R))]);
uicontrol(handles.main_fig,'Units','normalized','position',[.6 .55 .35 .15],'Style','popupmenu','FontSize',24,'String',labels,'Callback',@addToCallback);
uicontrol(handles.main_fig,'Units','normalized','position',[.6 .70 .1 .05],'Style','text','FontSize',24,'String','Add to:');

handles.reduced_data = [];

prettyFig('font_units','points');


editon = 0; % this C a mode selector b/w editing and looking

% plot the clusters
clusterPlot;

uiwait(handles.main_fig);

    function closeManualCluster(~,~)
        % first make sure that there are no unassigned data points
        if min(idx) == 0
            unassigned_data = find(idx==0);
            assignations = NaN*unassigned_data;
            % create a duplicate dataset with unassigned data at Infinity
            
            for i = 1:length(unassigned_data)
                % find closest assigned point
                R2 = R;
                R2(:,setdiff(unassigned_data,unassigned_data(i))) = NaN;
                % find distance to all points
                d=((R2(1,unassigned_data(i))-R2(1,:)).^2 + (R2(2,unassigned_data(i))-R2(2,:)).^2); 
                % set self distance to Inf
                d(unassigned_data(i)) = NaN;
                [~,loc]=min(d);
                assignations(i) = idx(loc);            
            end
            idx(idx==0) = assignations;
            clusterPlot;
        end
        delete(handles.main_fig)
        return
    end

    function addToCallback(src,~)
        editon = 1;
        src_string = get(src,'String');
        src_value = get(src,'Value');
        this_cluster_name = src_string{src_value};
        set(handles.main_fig,'Name',['Circle points to add to ' this_cluster_name]);
        set(handles.main_fig,'Color',c(src_value,:));
        ifh = imfreehand(handles.ax(1));
        p = getPosition(ifh);
        inp = inpolygon(R(1,:),R(2,:),p(:,1),p(:,2));

        idx(inp) = src_value;
        clusterPlot;
        editon = 0;
        set(handles.main_fig,'Color','w');
        set(handles.main_fig,'Name',[mat2str(length(find(inp))) ' points added to ' this_cluster_name]);

        uiwait(handles.main_fig);
    end

	function clusterPlot(~,~)
        if isempty(handles.reduced_data)
            % plotting for the first time
            for i = 1:length(labels)
                handles.reduced_data(i+1) = plot(NaN,NaN);
                handles.sorted_full_data(i) = plot(handles.ax(2),NaN,NaN,'Color',c(i,:),'LineWidth',2);
            end
            % plot unassigned data
            handles.reduced_data(1) = plot(handles.ax(1),R(1,:),R(2,:),'+','Color',[.5 .5 .5]);
            
            if length(X) > 100
                plotX = X(:,1:floor(length(X)/100):end);
            else
                plotX = X;
            end
            plot(handles.ax(2),plotX,'Color',[.5 .5 .5]);
            handles.current_pt_raw_data = plot(handles.ax(2),NaN,NaN);
            set(handles.ax(2),'YLim',[min(min(X)) max(max(X))],'XLim',[1 size(X,1)])
        else
            set(handles.reduced_data(1),'XData',R(1,idx==0),'YData',R(2,idx==0),'Parent',handles.ax(1),'Marker','+','LineStyle','none','MarkerFaceColor','none','Color',[.5 .5 .5]);
            for i = 2:length(labels)+1
                set(handles.reduced_data(i),'XData',R(1,idx==i-1),'YData',R(2,idx==i-1),'Parent',handles.ax(1),'Marker','o','LineStyle','none','MarkerFaceColor',c(i-1,:),'MarkerEdgeColor',c(i-1,:));
            end

            % average the raw data over the sorted clusters and plot those
            for i = 1:length(labels)
                plotX = X(:,idx == i);
                handles.sorted_full_data(i).XData = 1:size(plotX,1);
                handles.sorted_full_data(i).YData = nanmean(plotX,2);
                uistack(handles.sorted_full_data(i),'top')
            end
            drawnow
            
        end
    end


   function mouseCallback(~,~)

        if editon == 1
            return
        end
        if gca == handles.ax(1)
            pp = get(handles.ax(1),'CurrentPoint');
            p(1) = (pp(1,1)); p(2) = pp(1,2);


            x = R(1,:); y = R(2,:);
            [~,cp] = min((x-p(1)).^2+(y-p(2)).^2); % cp C the index of the chosen point
            if length(cp) > 1
                cp = min(cp);
            end


            % now plot the data vector corresponding to this plot on the secondary axis
            if idx(cp) == 0
                % gray point
                set(handles.current_pt_raw_data,'Parent',handles.ax(2),'YData',X(:,cp),'XData',1:length(X(:,cp)),'Color','k','LineWidth',3);
            else
                set(handles.current_pt_raw_data,'Parent',handles.ax(2),'YData',X(:,cp),'XData',1:length(X(:,cp)),'Color',c(idx(cp),:),'LineWidth',3);
            end

            % update the Ylims to focus on the current data 
            ylim = [min(X(:,cp)) max(X(:,cp))];
            if ylim(2) > ylim(1)
                set(handles.ax(2),'YLim',ylim)
            end

            % also run the external callback
            try
                runOnClick(cp)
            catch
            end
        end
     
    end

end