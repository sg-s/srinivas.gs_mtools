% manualCluster
% creates a GUI to manually cluster 2D data into clusters
% the number of the clusters and the labels are defined in labels, which is a cell array
% 
% usage:
% idx = manualCluster(R,X,labels);
% 
% where
% R is a 2 x N matrix
% X is a D x N matrix, which is the non-reduced data 
% labels is a cell array what is M elements long, where you want to cluster into M clusters
% idx is a vector N elements long
% 
% created by Srinivas Gorur-Shandilya at 10:53 , 03 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function idx = manualCluster(R,X,labels)

% defensive programming
if size(R,1) ~= 2
    R = R';
end
assert(length(R)==length(X),'reduced and full data should be of equal lengths')
assert(length(labels)>1,'there should be at least two labels provided')
assert(iscell(labels),'Labels should be cell array')

idx = zeros(1,length(R)); % stores the cluster ID

% make a colour scheme
c = parula(length(labels)+1);

% make the UI
hmc = figure('Name','manualCluster','WindowButtonDownFcn',@mansortmouse,'NumberTitle','off','position',[50 150 1200 700], 'Toolbar','figure','Menubar','none','CloseRequestFcn',@closeManualCluster); hold on,axis off
hm1 = axes('parent',hmc,'position',[-0.1 0.1 0.85 0.85],'box','on','TickDir','out');axis square, hold on ; title('Reduced Data')
hm2 = axes('parent',hmc,'position',[0.6 0.1 0.3 0.3],'box','on','TickDir','out');axis square, hold on  ; title('Raw data'), set(gca,'YLim',[min(min(R)) max(max(R))]);
add_control = uicontrol(hmc,'Units','normalized','position',[.6 .55 .35 .15],'Style','popupmenu','FontSize',24,'String',labels,'Callback',@add_to_callback);
uicontrol(hmc,'Units','normalized','position',[.6 .70 .1 .05],'Style','text','FontSize',24,'String','Add to:');


prettyFig;


editon = 0; % this C a mode selector b/w editing and looking

% plot the clusters
clusterplot;

uiwait(hmc);

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
            clusterplot;
            pause(1)
        end
        delete(hmc)
        return
    end

    function add_to_callback(src,~)
        editon = 1;
        this_cluster_name = src.String{src.Value};
        set(hmc,'Name',['Circle points to add to ' this_cluster_name]);
        set(hmc,'Color',c(src.Value,:));
        ifh = imfreehand(hm1);
        p = getPosition(ifh);
        inp = inpolygon(R(1,:),R(2,:),p(:,1),p(:,2));

        idx(inp) = src.Value;
        clusterplot;
        editon = 0;
        set(hmc,'Color','w');
        set(hmc,'Name',[mat2str(length(find(inp))) ' points added to ' this_cluster_name]);

        uiwait(hmc);
    end

	function clusterplot(~,~)

         cla(hm1); cla(hm2)    
         % plot all the reduced data and colour appropriately
         unassigned_data = find(idx == 0);
         if ~isempty(unassigned_data)
            plot(hm1,R(1,unassigned_data),R(2,unassigned_data),'+','Color',[.5 .5 .5])
         end
         a = nonzeros(unique(idx));
         for i = 1:length(a)
            this_cluster = a(i);
            plot(hm1,R(1,idx==this_cluster),R(2,idx==this_cluster),'o','MarkerFaceColor',c(this_cluster,:),'Color',c(this_cluster,:))
        end

        % also plot all the data
        plot(hm2,X,'Color',[.5 .5 .5])
        set(hm2,'YLim',[min(min(X)) max(max(X))],'XLim',[1 size(X,1)])
         
         
         
    end


   function mansortmouse(~,~)

        if editon == 1
            return
        end
        if gca == hm1
             pp = get(hm1,'CurrentPoint');
             p(1) = (pp(1,1)); p(2) = pp(1,2);
             x = R(1,:); y = R(2,:);
             [~,cp] = min((x-p(1)).^2+(y-p(2)).^2); % cp C the index of the chosen point
                if length(cp) > 1
                    cp = min(cp);
                end
            % refresh the plot        
             clusterplot;

             % now plot the data vector corresponding to this plot on the secondary axis
             if idx(cp) == 0
                % gray point
                plot(hm2,X(:,cp),'Color','k','LineWidth',3);
            else
                plot(hm2,X(:,cp),'Color',c(idx(cp),:),'LineWidth',3);
            end
        end
     
    end

end