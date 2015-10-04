% prettyFig.m
% makes current figure pretty:
% 1. makes all line widths of plots 2
% 2. turns on all minor ticks
% 3. makes all font sizes bigger
% 4. makes all plots thicker 
% 5. (optional) equalises Y axis in all subplots. to use: prettyFig('EqualiseY=1;')
% 6. makes figure background white
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = prettyFig(varargin)

warning off

% defaults
lw = 2; % line width of graphical elements
plw = 2; % plot line width 
fs = 24; % font size
EqualiseY = 0;
EqualiseX = 0;
FixLogX = 0;
FixLogY = 0;
plot_buffer = .1; % how much should you zoom out of the data to show extremes?


% evaluate option inputs
for i = 1:nargin
	eval(varargin{i})
end

% get handle to all plots in current figure
axesHandles = findall(gcf,'type','axes');

% for each axis
for i = 1:length(axesHandles)
	% get the old limits
	oldx = get(axesHandles(i),'XLim');
	oldy = get(axesHandles(i),'YLim');

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

	if ~isempty(minx) && ~isempty(maxx) && ~isempty(nonzeros([maxy miny]))
		rx = abs(minx-maxx); ry = abs(miny-maxy);
		if rx == 0
			rx = 1; minx = minx - 1; maxx = maxx + 1;
		end
		if ry == 0
			ry == 1; miny = miny - 1; maxy = maxy + 1;
		end
		
		if strcmp(get(axesHandles(i),'XScale'),'log')
			if strcmp(get(axesHandles(i),'XLimMode'),'auto')
				set(axesHandles(i),'XLim',oldx)
			end
		else
			if strcmp(get(axesHandles(i),'XLimMode'),'auto')
				set(axesHandles(i),'XLim',[minx-plot_buffer*rx maxx+plot_buffer*rx])
			end
		end

		if strcmp(get(axesHandles(i),'YScale'),'log')
			if strcmp(get(axesHandles(i),'YLimMode'),'auto')
				set(axesHandles(i),'YLim',oldy)
			end
		else
			if strcmp(get(axesHandles(i),'YLimMode'),'auto')
				try
					set(axesHandles(i),'YLim',[miny-plot_buffer*ry maxy+plot_buffer*ry])
				catch
				end
			end
		end


		
		
	end

	% turn the minor ticks on
	set(axesHandles(i),'XMinorTick','on','YMinorTick','on')	

	% there should be more than 1 xtick when we have a log scale
	if  length(get(axesHandles(i),'XTick')) == 1 && strcmp(get(axesHandles(i),'XScale'),'log')
		c=get(axesHandles(i),'Children');
		minlog = Inf;maxlog = -Inf;
		for k = 1:length(c)
			minlog = min([ min(nonzeros(get(c(1),'XData'))) minlog]);
			maxlog = max([ max(nonzeros(get(c(1),'XData'))) maxlog]);
		end
		a = ceil(log10(minlog));
		z = floor(log10(maxlog));
		if length(a:z) > 2
			set(axesHandles(i),'XTick',10.^(a:z));
		else
		end
	else

	end

	% there should be more than 1 Ytick when we have a log scale
	if  length(get(axesHandles(i),'YTick')) == 1 && strcmp(get(axesHandles(i),'YScale'),'log') && FixLogY

		c=get(axesHandles(i),'Children');
		minlog = Inf; maxlog = -Inf;
		for k = 1:length(c)
			minlog = min([ min(nonzeros(get(c(k),'YData'))) minlog]);
			maxlog = max([ max(nonzeros(get(c(k),'YData'))) maxlog]);
		end
		a = ceil(log10(minlog));
		z = floor(log10(maxlog));
		if length(a:z) > 2
			set(axesHandles(i),'YTick',10.^(a:z));
		else
			% choose a smaller base
			a = ceil(log(minlog));
			z = floor(log(maxlog));
			L = {};
			for ke = a:z
				%L = [L strcat('e^{',mat2str(ke),'}')];
				L = [L oval(exp(ke))];
			end
			set(axesHandles(i),'YTick',exp(a:z),'YTickLabel',L);

		end
		
	else
	end

	% there should be more than 1 Xtick when we have a log scale
	if  length(get(axesHandles(i),'XTick')) < 3 && strcmp(get(axesHandles(i),'XScale'),'log') && FixLogX

		c=get(axesHandles(i),'Children');
		minlog = Inf; maxlog = -Inf;
		for k = 1:length(c)
			minlog = min([ min(nonzeros(abs(get(c(k),'XData')))) minlog]);
			maxlog = max([ max(nonzeros(abs(get(c(k),'XData')))) maxlog]);
		end
		a = floor(log10(minlog));
		z = ceil(log10(maxlog));

		set(axesHandles(i),'XTick',10.^(a:z));

		% if length(a:z) > 2
		% 	set(axesHandles(i),'XTick',10.^(a:z));
		% else
		% 	% choose a smaller base
		% 	a = ceil(log(minlog));
		% 	z = floor(log(maxlog));
		% 	L = {};
		% 	for ke = a:z
		% 		% L = [L strcat('e^{',mat2str(ke),'}')];
		% 		L = [L oval(exp(ke))];
		% 	end
		% 	set(axesHandles(i),'XTick',exp(a:z),'XTickLabel',L);

		% end
		
	else
	end

	% there should be more than 1 Ytick when we have a log scale
	if  length(get(axesHandles(i),'YTick')) < 3 && strcmp(get(axesHandles(i),'YScale'),'log') && FixLogY

		c=get(axesHandles(i),'Children');
		minlog = Inf; maxlog = -Inf;
		for k = 1:length(c)
			minlog = min([ min(nonzeros(abs(get(c(k),'YData')))) minlog]);
			maxlog = max([ max(nonzeros(abs(get(c(k),'YData')))) maxlog]);
		end
		a = floor(log10(minlog));
		z = ceil(log10(maxlog));

		set(axesHandles(i),'YTick',10.^(a:z));


		% if length(a:z) > 2
		% 	set(axesHandles(i),'XTick',10.^(a:z));
		% else
		% 	% choose a smaller base
		% 	a = ceil(log(minlog));
		% 	z = floor(log(maxlog));
		% 	L = {};
		% 	for ke = a:z
		% 		% L = [L strcat('e^{',mat2str(ke),'}')];
		% 		L = [L oval(exp(ke))];
		% 	end
		% 	set(axesHandles(i),'XTick',exp(a:z),'XTickLabel',L);

		% end
		
	else
	end



	% find all errorbar plots and set those line widths appropriately
	ph=get(axesHandles(i),'Children');
	for j = 1:length(ph)
		try
			% only change the Line Width if default
			if ph(j).LineWidth == .5
				set(ph(j),'LineWidth',plw);
			end
		catch
			% probably an image or something.
			% so reverse tick direction
			set(gca,'TickDir','out')
			box on
		end
	end

	

end
clear i


% find all line plots and get all their X and Y extents
ph = findall(axesHandles,'type','line');
for j = 1:length(ph)
	if ph(j).LineWidth == .5
		set(ph(j),'LineWidth',plw)
	end
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

if EqualiseX
	xmin = Inf;
	xmax = -Inf;
	for i = 1:length(axesHandles)
		xl = get(axesHandles(i),'XLim');
		xmin = min([xmin xl]);
		xmax = max([xmax xl]);
	end
	clear i

	for i = 1:length(axesHandles)
		set(axesHandles(i),'XLim',[xmin xmax])
	end
	clear i

end

% turn on minor ticks
for i = 1:length(axesHandles)
	set(axesHandles(i),'XMinorTick','on');
end

% flip tick direction
for i = 1:length(axesHandles)
	set(axesHandles(i),'TickDir','out');
end

set(gcf,'Color','w')

warning on
