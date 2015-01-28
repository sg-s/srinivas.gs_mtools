% DesignFig.m
% interactively design a figure with multiple subplots and get DesignFig to make the code for you
% 
% created by Srinivas Gorur-Shandilya at 10:06 , 28 January 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = DesignFig()

allrect = struct;	
nplots = 0;

f =figure('Toolbar','none','Menubar','none','Name','Figure Designer','NumberTitle','off'); hold on
set(gca,'Position',[0 0 1 .95],'box','on','XLim',[0 1],'YLim',[0 1])

AddSubplotControl = uicontrol(f,'Units','normalized','Position',[.01 .96 .1 .03],'Style','pushbutton','Enable','on','String','Add plot','FontSize',10,'Callback',@AddRect);

SnapControl = uicontrol(f,'Units','normalized','Position',[.13 .96 .1 .03],'Style','pushbutton','Enable','on','String','Snap','FontSize',10,'Callback',@Snap);

function [] = AddRect(~,~)
	nplots = nplots+1;
	allrect(nplots).h = imrect;
end

function [] = Snap(~,~)
	keyboard
end

end