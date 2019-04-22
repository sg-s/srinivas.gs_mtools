% restyles an axes to show minimal "neuroscience-style" axes
function makeEphys(varargin)

% grab axes handles, if they exist 
if strcmp(class(varargin{1}),'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end



% options and defaults
options.time_units = 's';
options.time_scale = 1;
options.voltage_scale = 50;
options.voltage_position = -80;
options.voltage_units = 'mV';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});


for i = 1:length(ax)

	% put the bottom of the ylim where the voltage position is
	ax(i).YLim(1) = options.voltage_position;

	% add some X-padding 
	ax(i).XLim(1) = ax(i).XLim(1) -diff(ax(i).XLim)/10;

	% put only one tick on the YAxes
	ax(i).YTick = ax(i).YLim(1) + options.voltage_scale/2;
	ax(i).YTickLabel = [strlib.oval(options.voltage_scale) options.voltage_units];

	% add a white line to mask the rest of the Y-axis
	plot(ax(i),[ax(i).XLim(1) ax(i).XLim(1)],[ax(i).YLim(1) + options.voltage_scale ax(i).YLim(2)],'Color','w','LineWidth',4)

	% put only one tick on the XAxes
	ax(i).XTick = ax(i).XLim(1) + options.time_scale/2;
	ax(i).XTickLabel = [strlib.oval(options.time_scale) options.time_units];

	% add a white line to mask the rest of the X-axis
	plot(ax(i),[ax(i).XLim(1) + options.time_scale ax(i).XLim(2)],[ax(i).YLim(1) ax(i).YLim(1)],'Color','w','LineWidth',4)


	ax(i).TickLength = [0 0];

end