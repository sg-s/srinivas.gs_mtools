% PrettyFig.m
% makes current figure pretty:
% 1. makes all line widths of plots 2
% 2. turns on all minor ticks
% 3. makes all font sizes bigger
% 4. makes all plots thicker 
% 5. (optional) equalises Y axis in all subplots. to use: PrettyFig('EqualiseY=1;')
% 6. makes figure background white
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = PrettyFig(varargin)

% defaults
lw = 2; % line width of graphical elements
plw = 2; % plot line width 
fs = 24; % font size
EqualiseY = 0;
plot_buffer = .1; % how much should you zoom out of the data to show extremes?


% evaluate option inputs
for i = 1:nargin
	eval(varargin{i})
end

% get handle to all plots in current figure
axesHandles = findall(gcf,'type','axes');

% for each axis
for i = 1:length(axesHandles)
	% set line width and font size
	set(axesHandles(i),'FontSize',fs,'LineWidth',lw)

	% rescale the X and Y limits, but only if the user has not manually specified something
	ph = findall(axesHandles(i),'type','line');
	xlimits = NaN(2,length(ph));
	ylimits = NaN(2,length(ph));
	for j = 1:length(ph)
		temp=get(ph(j),'XData');
		xlimits(1,j) = min(temp); xlimits(2,j) = max(temp); clear temp
		temp=get(ph(j),'YData');
		ylimits(1,j) = min(temp); ylimits(2,j) = max(temp); clear temp
	end
	clear j
	minx=min(xlimits(1,:)); miny = min(ylimits(1,:)); 
	maxx=max(xlimits(2,:)); maxy = max(ylimits(2,:)); 
	rx = abs(minx-maxx); ry = abs(miny-maxy);
	
	if strcmp(get(axesHandles(i),'XLimMode'),'auto')
		set(axesHandles(i),'XLim',[minx-plot_buffer*rx maxx+plot_buffer*rx])
	end
	if strcmp(get(axesHandles(i),'YLimMode'),'auto')
		set(axesHandles(i),'YLim',[miny-plot_buffer*ry maxy+plot_buffer*ry])
	end
end
clear i

% find all line plots and get all their X and Y extents
ph = findall(axesHandles,'type','line');
for j = 1:length(ph)
	set(ph(j),'LineWidth',plw)
end
clear j


% find all titles
th = findall(axesHandles,'type','text');
for j = 1:length(th)
	set(th(j),'FontSize',fs)
end
clear j


if EqualiseY 
	ymin = Inf;
	ymax = -Inf;
	for i = 1:length(axesHandles)
		yl = get(axesHandles(i),'YLim');
		ymin = min([ymin yl]);
		ymax = max([ymax yl]);
	end
	clear i

	for i = 1:length(axesHandles)
		set(axesHandles(i),'YLim',[ymin ymax])
	end
	clear i

end

set(gcf,'Color','w')