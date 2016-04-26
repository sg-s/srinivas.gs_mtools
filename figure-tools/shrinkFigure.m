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
options.sub_sample = 100;

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


for i = 1:length(axesHandles)
	% get the x and y limits
	xlim = axesHandles(i).XLim;
	ylim = axesHandles(i).YLim;

	% get the data
	c = get(axesHandles(i),'Children');
	for j = 1:length(c)
		if strcmp(get(c(j),'Type'),'line')
			x = get(c(j),'XData');
			y = get(c(j),'YData');

			% crop to the viewport 
			rm_this = x < xlim(1) | x > xlim(2) | y < ylim(1) | y > ylim(2);
			x(rm_this) = [];
			y(rm_this) = [];
			warning off
			c(j).XData = x;
			c(j).YData = y;
			warning on
		else
			disp('not line')
			keyboard
		end 
	end
end