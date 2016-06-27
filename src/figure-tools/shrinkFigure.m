% shrinkFigure.m
% shrinks MATLAB figures by downsampling, omitting, and re-plotting data
% use this to make figures that are visually identical, but much smaller
% DO NOT use this on figures that you treat as data -- this is meant purely for optimisation 
% for printing and export. 

function [varargout] = shrinkFigure(varargin)

% get options from dependencies 
options = getOptionsFromDeps(mfilename);

% options and defaults
options.crop_to_viewport = true;
options.distance_to_next_point = 2; % in pixels
options.ignore_plots_shorted_than = 500; % data points
options.debug = true;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
if iseven(length(varargin))
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


% get handle to all plots in current figure
axesHandles = findall(gcf,'type','axes');

% get the dimensions of the figure
cf = gcf;
assert(strcmp(cf.Units,'pixels'),'Figure Position should be in pixels')
fig_width = cf.Position(3);
fig_height = cf.Position(4);

for i = 1:length(axesHandles)
	% get the x and y limits
	xlim = axesHandles(i).XLim;
	ylim = axesHandles(i).YLim;

	% get the data
	c = get(axesHandles(i),'Children');
	for j = 1:length(c)
		if strcmp(get(c(j),'Type'),'line') || strcmp(get(c(j),'Type'),'scatter')
			x = get(c(j),'XData');
			y = get(c(j),'YData');

			% subsample only if its very big, and if it's on a linear scale
			if length(x) > options.ignore_plots_shorted_than && strcmp(c(j).Parent.XScale,'linear') && strcmp(c(j).Parent.YScale,'linear')

				assert(strcmp(c(j).Parent.Units,'normalized'),'Expected axes units to be "normalized"')

				shrinkDataInPlot(c(j),options.distance_to_next_point)
				
			end % end check for size of data
		else
			if options.debug
				disp('not a line or a scatter')
			end
		end 
	end
end