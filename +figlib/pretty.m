% makes a figure prettier, and overrides MATLAB's horrible defaults. 
% 
% usage:
% prettyFig; % will automatically make the current figure prettier
% 
% you can tweak individual options if you like. for example:
% prettyFig('lw',4) % set line width of axes to 4 
% prettyFig('tick_length',.005) % change the tick length
% 
% to see all the options, you can 
% options = prettyFig
% to get a structure with all the options
% you can also pass this options structure back in:
%
% prettyFig(options)
%
% To see this help message, type:
% help prettyFig
%

function [varargout] = pretty(varargin)

warning off


% options and defaults
options.LineWidth = 1.5; % line width of graphical elements
options.PlotLineWidth = 1.5; % plot line width
options.FontSize = 18; % font size
options.EqualiseY = false;
options.EqualiseX = false;
options.FixLogX = true;
options.FixLogY = true;
options.PlotBuffer = 0; % how much should you zoom out of the data to show extremes?
options.TickLength = 5; % pixels
options.XMinorTicks = false;
options.YMinorTicks = false;
options.font_units = 'points';
options.legend_box = false;
options.TickDir = 'out';
options.AxisBox = 'on';
options.LatexPrefix = '\mathrm';
options.AxesColor = [.4 .4 .4];

if nargout && ~nargin 
	varargout{1} = options;
	return
end

% if a axes handle is provided, use it
if nargin == 0
	use_this_figure = gcf;
else
	if isa(varargin{1},'matlab.ui.Figure')
		use_this_figure = varargin{1};
		varargin(1) = [];
	else
		use_this_figure = gcf;
	end
end



options = corelib.parseNameValueArguments(options, varargin{:});


% get handle to all plots in figure
axesHandles = findall(use_this_figure,'type','axes');

longest_axes_length = NaN(length(axesHandles),1);


% for each axis
for i = 1:length(axesHandles)

	% set color 
	if ~min(axesHandles(i).XColor)  == 1
		axesHandles(i).XColor = options.AxesColor;
	end
	if ~min(axesHandles(i).YColor)  == 1
		axesHandles(i).YColor = options.AxesColor;
	end


	% get the old limits
	oldx = get(axesHandles(i),'XLim');
	oldy = get(axesHandles(i),'YLim');

	% first change the units 
	set(axesHandles(i),'FontUnits',options.font_units)
	% set line width and font size
	set(axesHandles(i),'FontSize',options.FontSize,'LineWidth',options.LineWidth)
	% change it back to points
	axesHandles(i).FontUnits = 'points';

	% rescale the X and Y limits, but only if the user has not manually specified something
	ph = findall(axesHandles(i),'type','line');
	xlimits = NaN(2,length(ph));
	ylimits = NaN(2,length(ph));


	% find the length of the longest axis
	pos_temp = get(axesHandles(i),'Position');
	longest_axes_length(i) = max(pos_temp(3:4).*use_this_figure.Position(3:4));

	if isa(axesHandles(i).XAxis,'matlab.graphics.axis.decorator.DatetimeRuler')
		continue
	end

	if isa(axesHandles(i).YAxis,'matlab.graphics.axis.decorator.DatetimeRuler')
		continue
	end

	for j = 1:length(ph)
		temp=get(ph(j),'XData');
		if isempty(temp)
			continue
		end
		xlimits(1,j) = min(temp); xlimits(2,j) = max(temp); clear temp
		temp=get(ph(j),'YData');
		if isempty(temp)
			continue
		end
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
			ry = 1; miny = miny - 1; maxy = maxy + 1;
		end
		
		if strcmp(get(axesHandles(i),'XScale'),'log')
			if strcmp(get(axesHandles(i),'XLimMode'),'auto')
				set(axesHandles(i),'XLim',oldx)
			end
		else
			if strcmp(get(axesHandles(i),'XLimMode'),'auto')
				try
					set(axesHandles(i),'XLim',[minx-options.PlotBuffer*rx maxx+options.PlotBuffer*rx])
				catch
				end
			end
		end

		if strcmp(get(axesHandles(i),'YScale'),'log')
			if strcmp(get(axesHandles(i),'YLimMode'),'auto')
				set(axesHandles(i),'YLim',oldy)
			end
		else
			if strcmp(get(axesHandles(i),'YLimMode'),'auto')
				try
					set(axesHandles(i),'YLim',[miny-options.PlotBuffer*ry maxy+options.PlotBuffer*ry])
				catch
				end
			end
		end
	end

	% turn the minor ticks on
	if options.XMinorTicks
		set(axesHandles(i),'XMinorTick','on');
	else
		set(axesHandles(i),'XMinorTick','off');
	end
	if options.YMinorTicks
		set(axesHandles(i),'YMinorTick','on');
	else
		set(axesHandles(i),'YMinorTick','off');
	end	


	% there should be more than 2 Xtick when we have a log scale
	if  length(get(axesHandles(i),'XTick')) < 3 && strcmp(get(axesHandles(i),'XScale'),'log') && options.FixLogX
	
		a = floor(log10(axesHandles(i).XLim(1)));
		z = ceil(log10(axesHandles(i).XLim(2)));


		if isinf(a) | isinf(z)
		else
			az = a:z;

			az = [az(1) az(1:ceil(length(az)/5):end) az(end)];
			az = unique(az);

			axesHandles(i).XLim = [10^az(1) 10^az(end)];
			set(axesHandles(i),'XTick',10.^(az));
		end
		
	else
	end



	% there should be more than 1 Ytick when we have a log scale
	if  length(get(axesHandles(i),'YTick')) < 3 && strcmp(get(axesHandles(i),'YScale'),'log') && options.FixLogY

		a = floor(log10(axesHandles(i).YLim(1)));
		z = ceil(log10(axesHandles(i).YLim(2)));


		if isinf(a) | isinf(z)
		else
			az = a:z;

			az = [az(1) az(1:ceil(length(az)/5):end) az(end)];
			az = unique(az);

			axesHandles(i).YLim = [10^az(1) 10^az(end)];
			set(axesHandles(i),'YTick',10.^(az));
		end
		
	end



	% find all errorbar plots and set those line widths appropriately
	ph = get(axesHandles(i),'Children');
	for j = 1:length(ph)
		try
			% only change the Line Width if default
			if ph(j).LineWidth == .5
				set(ph(j),'LineWidth',options.PlotLineWidth);
			end
		catch
			% probably an image or something.
			% so reverse tick direction
			if strcmp(options.TickDir,'out')
				set(gca,'TickDir','out')
			else
				set(gca,'TickDir','in')
			end
			if strcmp(options.AxisBox,'on')
				box on
			else
				box off
			end
		end
	end

	

end
clear i

% set all tick marks to be the same absolute length
tl = options.TickLength;
for i = 1:length(axesHandles)
	tl_temp = get(axesHandles(i),'TickLength');
	tl_temp(1) =  tl/longest_axes_length(i);

	set(axesHandles(i),'TickLength',tl_temp);

end



% find all line plots and get all their X and Y extents
ph = findall(axesHandles,'type','line');
for j = 1:length(ph)
	if ph(j).LineWidth == .5
		set(ph(j),'LineWidth',options.PlotLineWidth)
	end
end
clear j



% find all titles
th = findall(axesHandles,'type','text');
for j = 1:length(th)
	set(th(j),'FontUnits',options.font_units)
	set(th(j),'FontSize',options.FontSize)
	set(th(j),'FontUnits','points')
end
clear j

% should we equalise axes?
if options.EqualiseY 
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

if options.EqualiseX
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

% flip tick direction
for i = 1:length(axesHandles)
	set(axesHandles(i),'TickDir','out');
end

set(use_this_figure,'Color','w')

% adjust legend boxes
legend_handles = findobj('-regexp','Tag','[^'']','-and','type','legend');
for i = 1:length(legend_handles)
	if options.legend_box 
		legend_handles(i).Box = 'on';
	else
		legend_handles(i).Box = 'off';
	end
end 


% add a prefix if the labels are using a latex interpreter
for i = 1:length(axesHandles)
	if strcmp(axesHandles(i).YLabel.Interpreter,'latex')
		if isempty(strfind(axesHandles(i).YLabel.String,options.LatexPrefix))
			% first strip all $ signs
			S = axesHandles(i).YLabel.String;
			dollar_signs = (strfind(S,'$'));
			if length(dollar_signs) ~= 2
				% give up
				continue
			end


			% append the prefix 
			S = [S(1:dollar_signs(1)) options.LatexPrefix '{' S(dollar_signs(1)+1:dollar_signs(2)-1) '}$' S(dollar_signs(2)+1:end)];

			axesHandles(i).YLabel.String = S;

		end
	end

	if strcmp(axesHandles(i).XLabel.Interpreter,'latex')
		if isempty(strfind(axesHandles(i).XLabel.String,options.LatexPrefix))
			% first strip all $ signs
			S = axesHandles(i).XLabel.String;
			dollar_signs = (strfind(S,'$'));
			if length(dollar_signs) ~= 2
				% give up
				continue
			end


			% append the prefix 
			S = [S(1:dollar_signs(1)) options.LatexPrefix '{' S(dollar_signs(1)+1:dollar_signs(2)-1) '}$' S(dollar_signs(2)+1:end)];

			axesHandles(i).XLabel.String = S;

		end
	end


end


% clean up X and Y ticks

for i = 1:length(axesHandles)
	X = axesHandles(i).XTickLabels;
	XT = axesHandles(i).XTick;

	if length(X) == 0 
		continue
	end

	if isnan(str2double(X{1}))
		continue
	end

	for j = 1:length(X)
		if any(strfind(X{j},'.')) & strcmp(X{j}(1),'0')
			X{j}(1) = '';
		end
	end
	axesHandles(i).XTickLabels = X;

end

for i = 1:length(axesHandles)
	Y = axesHandles(i).YTickLabels;
	YT = axesHandles(i).YTick;

	if length(Y) == 0 
		continue
	end

	if isnan(str2double(Y{1}))
		continue
	end

	for j = 1:length(Y)
		if any(strfind(Y{j},'.')) & strcmp(Y{j}(1),'0')
			Y{j}(1) = '';
		end
	end
	axesHandles(i).YTickLabels = Y;

	
end

% turn back tick labels to auto to allow zooming
for i = 1:length(axesHandles)
	axesHandles(i).YTickLabelMode = 'auto';
	axesHandles(i).XTickLabelMode = 'auto';
end

warning on
