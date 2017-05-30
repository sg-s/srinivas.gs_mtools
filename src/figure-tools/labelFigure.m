% labelFigure.m
% adds labels to each subplot of a figure so you can directly drop into a paper
% 
% created by Srinivas Gorur-Shandilya at 2:04 , 15 March 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [varargout] = labelFigure(varargin)

% options and defaults
options.capitalise = false;
options.x_offset = -.06;
options.y_offset = .01;
options.font_size = 20;
options.font_weight = 'bold';
options.delete_all = false;
options.column_first = false;
options.ignore_these = [];

if ~nargin && nargout == 1
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
else
	error('Inputs need to be name value pairs')
end	

if length(findobj) == 1
	return
end

% first wipe all previously existing labels in the figure
figure_children = get(gcf,'Children');
rm_this = false(length(figure_children));
for i = 1:length(figure_children)
	if strcmp(figure_children(i).Tag,'axes-label')
		rm_this(i) = true;
	end
end
delete(figure_children(rm_this))

% get all the axes from the current figure
axesHandles = findall(gcf,'type','axes');

if options.delete_all
	return
end

% ignore specified handles
rm_this = false(length(axesHandles),1);
for i = 1:length(options.ignore_these)
	rm_this(options.ignore_these(i) == axesHandles) = true;
end
axesHandles(rm_this) = [];

% remove suptitle from this list
rm_this = false(length(axesHandles),1);
for i = 1:length(axesHandles)
	if strcmp(get(axesHandles(i),'Tag'),'suptitle')
		rm_this(i) = true;
	end
	if strcmp(get(axesHandles(i),'Tag'),'inset')
		rm_this(i) = true;
	end
end
axesHandles(rm_this) = [];

% remove axes with identical positions (probably plotyy axes)
ap = NaN(length(axesHandles),1);
for i = 1:length(axesHandles)
	ap(i) = sum((2.^(1:4)).*([axesHandles(i).Position]));
end
[~,use_these] = unique(ap);
axesHandles = axesHandles(use_these);


% we need to make sure all the axes units are normalised...
if length(unique({axesHandles.Units})) == 1
	assert(strcmp(unique({axesHandles.Units}),'normalized'),'FATAL: All axes units must be "normalized"')
else
	error('FATAL: All axes units must be "normalized". Multiple axes units detected.')
end


% sort the axes by their positions so we get sensible labels
X = NaN(length(axesHandles),1);
Y = NaN(length(axesHandles),1);
for i = 1:length(axesHandles)
	X(i) = mean(axesHandles(i).Position([1 3]));
	Y(i) = mean(axesHandles(i).Position([2 4]));
end
Y = 1-Y;
if options.column_first
	[~,idx] = sort(10*(X.^2) + Y.^2);
else
	[~,idx] = sort(X.^2 + 10*(Y.^2));
end

temp = axesHandles;
for i = 1:length(idx)
	temp(i) = axesHandles(idx(i));
end
axesHandles = temp; clear temp

L = {};
for i = length(axesHandles):-1:1
	L{i} = char(96+i);
end

for i = length(axesHandles):-1:1
	label_handles(i) = labelAxes(axesHandles(i),L{i},options);
	uistack(label_handles(i),'top')
end

if nargout == 2
	varargout{2} = label_handles;
end