% Prevent axes from intersecting 
% 
% **Syntax**
%
% ```matlab
% axlib.axlib.separate()
% axlib.separate(ax_handle)
% axlib.separate(ax_handle,'MaskY',true)
% axlib.separate(ax_handle,'MaskX',true)
% axlib.separate(ax_handle,'MaskX',true,'Offset',.1)
% axlib.separate(ax_handle,options)
% ```
%
% **Description**
%
% Visually alters a plot so that it appears as though the X and Y
% axes are non-intersecting. It achieves this by plotting lines 
% that obscure that part of the axes. 
%
% See Also axlib.equalize
%



function mask_handles = separate(varargin)


% options and defaults
options.Offset = .1;
options.MaskX = true;
options.MaskY = true;


if nargout && ~nargin 
	varargout{1} = options;
    return
end

ax = [];
% pull out an axes handle if there is one
if ~nargin
	ax = gca;
else
	if isa(varargin{1},'matlab.graphics.axis.Axes')
		ax = varargin{1};
		varargin(1) = [];
		if length(ax) > 1
			mask_handles = struct('x',[],'y',[]);
			for i = 1:length(ax)
				if ~isempty(varargin)
					mask_handles(i) = axlib.separate(ax(i),varargin);
				else
					mask_handles(i) = axlib.separate(ax(i));
				end
			end
			return
		end
	else
		ax = gca;
	end
end



if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});


assert(options.Offset > 0,'Offset must be positive')

hold(ax,'on')

% determine what the current XTicks and YTicks are
xtick = ax.XTick;
ytick = ax.YTick;
ylabels = ax.YTickLabels;
xlabels = ax.XTickLabels;

% change X and Y lims 
old_xlim = ax.XLim;
old_ylim = ax.YLim;

x_range = abs(diff(old_xlim));
y_range = abs(diff(old_ylim));


% resize X and Y Lims
if strcmp(ax.XScale,'linear')
	ax.XLim = [old_xlim(2) - (1+options.Offset)*x_range old_xlim(2)];
else
	% work in log space
	temp = log(old_xlim);
	temp_range = abs(diff(temp));
	ax.XLim = [exp(temp(2) - temp_range*(1+options.Offset)) old_xlim(2)];
end
if strcmp(ax.YScale,'linear')
	ax.YLim = [old_ylim(2) - (1+options.Offset)*y_range old_ylim(2)];
else
	% work in log space
	temp = log(old_ylim);
	temp_range = abs(diff(temp));
	ax.YLim = [exp(temp(2) - temp_range*(1+options.Offset)) old_ylim(2)];
end

% force ticks to be where they should be
ax.XTick = xtick;
ax.YTick = ytick;
ax.XTickLabels = xlabels;
ax.YTickLabels = ylabels;

% draw white lines to hide the offending parts of the axes
if options.MaskX
	mask_handles.x = plot(ax,[ax.XLim(1) min(xtick)],[ax.YLim(1) ax.YLim(1)],'Color','w','LineWidth',ax.LineWidth+1,'HandleVisibility','off');
end
if options.MaskY
	mask_handles.y = plot(ax,[ax.XLim(1) ax.XLim(1)],[ax.YLim(1) min(ytick)],'Color','w','LineWidth',ax.LineWidth+1,'HandleVisibility','off');
end