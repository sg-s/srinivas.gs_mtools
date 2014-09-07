% PrettyFig.m
% makes current figure pretty:
% 1. makes all line widths of plots 2
% 2. turns on all minor ticks
% 3. makes all font sizes bigger
% 4. makes all plots thicker 
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


% evluate inputs
for i = 1:nargin
	eval(varargin{i})
end


% get handle to all plots in current figure
axesHandles = findall(gcf,'type','axes');

% for each axis
for i = 1:length(axesHandles)
	% set line width and font size
	set(axesHandles(i),'FontSize',fs,'LineWidth',lw)

	% find all line plots
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
end
clear i


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