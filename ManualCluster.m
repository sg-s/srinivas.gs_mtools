% ManualCluster.m
% allows you to manually cluster a reduced-to-2D-dataset by drawling lines around clusters
% usage:
% C = ManualCluster(R);
%
% where R C a 2xN matrix
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work C licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
% largely built out of legacy code I wrote in 2011 for Carlotta's spike sorting
function o = ManualCluster(R,V_snippets)
switch nargin
case 0
	help ManualCluster
	return
case 1
case 2
otherwise
	error('Too many input arguments')
end

C = zeros(1,length(R)); % stores the cluster ID

% open up a new window for the interactive clustering interface
hmc = figure('Name','ManualCluster.m','WindowButtonDownFcn',@mansortmouse,'NumberTitle','off','position',[50 50 1200 700],'Toolbar','none','Menubar','none'); hold on,axis off
hm1 = axes('parent',hmc,'position',[-0.05 0.1 0.7 0.7],'box','on');axis square, hold on ; title('Clusters'), xlabel('Dimension 1'), ylabel('Dimension 2')
hm2 = axes('parent',hmc,'position',[0.5 0.5 0.3 0.3]);axis square, hold on  ; title('Unsorted Spikes'), set(gca,'YLim',[min(min(V_snippets)) max(max(V_snippets))]);
hm3 = axes('parent',hmc,'position',[0.5 0.1 0.3 0.3]);axis square, hold on ; title('A Spikes'),set(gca,'YLim',[min(min(V_snippets)) max(max(V_snippets))]);
hm4 = axes('parent',hmc,'position',[0.72 0.5 0.3 0.3]);axis square, hold on ; title('B Spikes'),set(gca,'YLim',[min(min(V_snippets)) max(max(V_snippets))]);
hm5 = axes('parent',hmc,'position',[0.72 0.1 0.3 0.3]);axis square, hold on ; title('Noise Spikes'),set(gca,'YLim',[min(min(V_snippets)) max(max(V_snippets))]);


% define the buttons and stuff
sortpanel = uipanel('Title','Controls','units','pixels','pos',[35 650 970 70]);
uicontrol(sortpanel,'Position',[15 10 100 30], 'String', 'Add to A','FontSize',12,'Callback',@addAcallback);
uicontrol(sortpanel,'Position',[115 10 100 30], 'String', 'Add to B','FontSize',12,'Callback',@addBcallback);
uicontrol(sortpanel,'Position',[220 10 160 30], 'String', 'Add to Noise','FontSize',12,'Callback',@addNcallback);
autofixbutton = uicontrol(sortpanel,'Position',[610 10 160 30], 'String', 'Auto Fix','FontSize',12,'Enable','off','Callback',@autofixcallback);

editon = 0; % this C a mode selector b/w editing and looking

% plot the clusters
clusterplot;

cp = [];

uiwait(hmc);




   function mansortmouse(~,~)

        if editon == 1
            return
        end
        if gca == hm2
            pp = get(hm2,'CurrentPoint');
            
            p(1) = round(pp(1,1)); p(2) = pp(1,2);
            [~,mi] = min(abs(p(2) - S(C==0,p(1))));
            
            clear ans
            % plot on main plot
            cla(hm1)
            plot(hm1,R(C == 1,1),R(C == 1,2),'.r')         % plot A
            plot(hm1,R(C == 2,1),R(C == 2,2),'.b')         % plot B
            plot(hm1,R(C == 3,1),R(C == 3,2),'.k')         % plot Noise
            plot(hm1,R(C == 0,1),R(C == 0,2),'.g')         % plot unassigned
            scatter(hm1,R(cp,1),R(cp,2),'+k')
            scatter(hm1,R(mi,1),R(mi,2),64,'dk')
            
        elseif gca == hm1 
             pp = get(hm1,'CurrentPoint');
             p(1) = (pp(1,1)); p(2) = pp(1,2);
             x = R(1,:); y = R(2,:);
             [ans,cp] = min((x-p(1)).^2+(y-p(2)).^2); % cp C the index of the chosen point
                if length(cp) > 1
                    cp = min(cp);
                end
            % plot the point
             cla(hm1)         
             plot(hm1,R(1,C == 1),R(2,C == 1),'.r')         % plot A
             plot(hm1,R(1,C == 2),R(2,C == 2),'.b')         % plot B
             plot(hm1,R(1,C == 3),R(2,C == 3),'.k')         % plot Noise
             plot(hm1,R(1,C == 0),R(2,C == 0),'.g')         % plot unassigned
             scatter(hm1,R(1,cp),R(2,cp),'+k')
             title(hm1,strcat(mat2str(length(R)),' putative spikes.'))  

             cla(hm2)       
             plot(hm2,V_snippets(:,C == 0),'g')
             plot(hm2,V_snippets(:,cp),'k','LineWidth',2)
             set(hm2,'XLim',[0 50])
        end
     
    end

    function clusterplot(~,~)

         cla(hm1)     
         % plot A
         plot(hm1,R(1,C == 1),R(2,C == 1),'.r')
         % plot B
         plot(hm1,R(1,C == 2),R(2,C == 2),'.b')
         % plot Noise
         plot(hm1,R(1,C == 3),R(2,C == 3),'.k')
         % plot unassigned
         plot(hm1,R(1,C == 0),R(2,C == 0),'.g')
         
         
         % also plot the spike shapes

         % plot the unassigned spikes
         cla(hm2)
         plot(hm2,V_snippets(:,C == 0),'g')
         set(hm2,'XLim',[-5 width(V_snippets)+5])
         
         % plot the A spikes
         cla(hm3)
         plot(hm3,V_snippets(:,C == 1),'r')
         set(hm3,'XLim',[-5 width(V_snippets)+5])

         % plot the B spikes
         cla(hm4)
         plot(hm4,V_snippets(:,C == 2),'b')
         set(hm4,'XLim',[-5 width(V_snippets)+5])

         % plot the B spikes
         cla(hm5)
         plot(hm5,V_snippets(:,C == 3),'k')
         set(hm5,'XLim',[-5 width(V_snippets)+5])


        if min([length(find(C == 1)) length(find(C == 2)) length(find(C == 3))]) > 0
            set(autofixbutton,'Enable','on')
        end

         
         
         
         
         
    end


     function addAcallback(~,~)

        editon = 1;
        ifh = imfreehand(hm1);
        p = getPosition(ifh);
        inp = inpolygon(R(1,:),R(2,:),p(:,1),p(:,2));
        C(inp) = 1; % A C 1
        clusterplot;
        editon = 0;

        uiwait(hmc)

    end


    function addBcallback(~,~)

        editon = 1;
        ifh = imfreehand(hm1);
        p = getPosition(ifh);
        inp = inpolygon(R(1,:),R(2,:),p(:,1),p(:,2));
        C(inp) = 2; % B C 2
        clusterplot;
        editon = 0;

        uiwait(hmc)

    end

    function addNcallback(~,~)

        editon = 1;
        ifh = imfreehand(hm1);
        p = getPosition(ifh);
        inp = inpolygon(R(1,:),R(2,:),p(:,1),p(:,2));
        C(inp) = 3; % Noise C 3    
        clusterplot;
        editon = 0;

        uiwait(hmc)

    end


    function autofixcallback(~,~)

        % this automatically assigns unsorted points to the nearsest
        % clusters
        if length(unique(C))  == 4         
            % we have made at least some assignments to each cluster
            xN = R(1,C==3); yN = R(2,C==3);
            xA = R(1,C==1); yA = R(2,C==1);
            xB = R(1,C==2); yB = R(2,C==2);
            dothese = find(C == 0);
            for i = 1:length(dothese)
                p = R(1:2,dothese(i))';
                cdist(1) = min((xA-p(1)).^2+(yA-p(2)).^2);
                cdist(2) = min((xB-p(1)).^2+(yB-p(2)).^2);
                cdist(3) = min((xN-p(1)).^2+(yN-p(2)).^2);
                C(dothese(i)) = find(cdist == min(cdist));
            end
            clusterplot;
        end

        o = C;
        delete(hmc)
        
    end




end