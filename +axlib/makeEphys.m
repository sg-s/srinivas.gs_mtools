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
options.voltage_scale = 10;
options.voltage_position = -80;
options.voltage_units = 'mV';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});

% put the bottom of the ylim where the voltgae position is
ax.YLim(1) = options.voltage_position;

% add some X-padding 
ax.XLim(1) = ax.XLim(1) -diff(ax.XLim)/10;

% put only one tick on the YAxes
ax.YTick = ax.YLim(1) + options.voltage_scale/2;
ax.YTickLabel = [strlib.oval(options.voltage_scale) options.voltage_units];

% add a white line to mask the rest of the Y-axis
plot(ax,[ax.XLim(1) ax.XLim(1)],[ax.YLim(1) + options.voltage_scale ax.YLim(2)],'Color','w','LineWidth',2)

% put only one tick on the XAxes
ax.XTick = ax.XLim(1) + options.time_scale/2;
ax.XTickLabel = [strlib.oval(options.time_scale) options.time_units];

% add a white line to mask the rest of the X-axis
plot(ax,[ax.XLim(1) + options.time_scale ax.XLim(2)],[ax.YLim(1) ax.YLim(1)],'Color','w','LineWidth',2)


ax.TickLength = [0 0];