%
% **Syntax**
%
% ```matlab
% axlib.separate()
% axlib.separate(ax_handle)
% axlib.separate(ax_handle,'mask_y',true)
% axlib.separate(ax_handle,'mask_x',true)
% axlib.separate(ax_handle,'mask_x',true,'offset',.1)
% axlib.separate(ax_handle,options)
% ```
%
% **Description**
%
% Visually alters a plot so that it appears as though the X and Y
% axes are non-intersecting. It achieves this by plotting lines 
% that obscure that part of the axes. 
%
% !!! info "See Also"
%     ->axlib.equalize
%



function mask_handles = separate(varargin)


% options and defaults
options.offset = .1;
options.mask_x = true;
options.mask_y = true;


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
					mask_handles(i) = separate(ax(i),varargin);
				else
					mask_handles(i) = separate(ax(i));
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

% validate and accept options
if mathlib.iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end


assert(options.offset > 0,'Offset must be positive')

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
	ax.XLim = [old_xlim(2) - (1+options.offset)*x_range old_xlim(2)];
else
	% work in log space
	temp = log(old_xlim);
	temp_range = abs(diff(temp));
	ax.XLim = [exp(temp(2) - temp_range*(1+options.offset)) old_xlim(2)];
end
if strcmp(ax.YScale,'linear')
	ax.YLim = [old_ylim(2) - (1+options.offset)*y_range old_ylim(2)];
else
	% work in log space
	temp = log(old_ylim);
	temp_range = abs(diff(temp));
	ax.YLim = [exp(temp(2) - temp_range*(1+options.offset)) old_ylim(2)];
end

% force ticks to be where they should be
ax.XTick = xtick;
ax.YTick = ytick;
ax.XTickLabels = xlabels;
ax.YTickLabels = ylabels;

% draw white lines to hide the offending parts of the axes
if options.mask_x
	mask_handles.x = plot(ax,[ax.XLim(1) min(xtick)],[ax.YLim(1) ax.YLim(1)],'Color','w','LineWidth',ax.LineWidth+1,'HandleVisibility','off');
end
if options.mask_y
	mask_handles.y = plot(ax,[ax.XLim(1) ax.XLim(1)],[ax.YLim(1) min(ytick)],'Color','w','LineWidth',ax.LineWidth+1,'HandleVisibility','off');
end