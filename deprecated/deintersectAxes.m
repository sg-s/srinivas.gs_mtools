% deintersectAxes
% magical function that visually mimics axes that do not intersect
% only to be used on publication-ready figures;
% this takes extreme liberties with your figure -- 
% do not do anything else to a figure after you have run this on a axis
%
% part of mtools, which lives here:
% https://github.com/sg-s/srinivas.gs_mtools
% 
% usage:
% deintersectAxes; % deintersects axes of current axes
% deintersectAxes('pixel_offset',10); % define how much you want to offset the axes
% deintersectAxes(ax_handle,...); operate on a specific axes 
% 
function [] = deintersectAxes(varargin)

warning('The use of deintersectAxes is discouraged. Use seperateAxes() instead')

% options and defaults
options.pixel_offset = 10;

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
			for i = 1:length(ax)
				if ~isempty(varargin)
					deintersectAxes(ax(i),varargin);
				else
					deintersectAxes(ax(i));
				end
			end
			return
		end
	else
		ax = gca;
	end
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
    		options = setfield(options,temp,varargin{ii+1});
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end


% we can't have a box on 
ax.Box = 'off';

%% duplicate the axes
axX = copyobj(ax,ax.Parent);
axY = copyobj(ax,ax.Parent);

% inherit the XLim and XTick from the parent
axX.XLim = ax.XLim;
axY.YLim = ax.YLim;
axX.XTick = ax.XTick;
axY.YTick = ax.YTick;

% wipe all data from the new objects
delete(axX.Children)
delete(axY.Children)

% remove titles from the new axes
title(axX,'');
title(axY,'');

% turn axes off in parent
axis(ax,'off')
uistack(ax,'top')

% make white some axes and remove superfluous stuff that will be hidden anyway
axX.YTick = []; axY.XTick = []; 
xlabel(axY,''); ylabel(axX,'');
axX.YColor = 'w'; axY.XColor = 'w';

% get the X and Y dimensions of the figure
sz = ax.Parent.Position(3:4);

% ensure that the axes location is in normalised units
assert(strcmp(ax.Units,'normalized'),'Axes units should be normalized')

% move the x axis down a bit
axX.Position(2) = axX.Position(2) - options.pixel_offset/sz(2);

% move the Y axis to the left a bit
axY.Position(1) = axY.Position(1) - options.pixel_offset/sz(1);

% move the hidden Y axis to the right -- this way we can manually specify the XLim to get a nice tick
axX.YAxisLocation = 'right';