% adds labels to each subplot of a figure 
% 
% created by Srinivas Gorur-Shandilya at 2:04 , 15 March 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [varargout] = label(varargin)


% options and defaults
options.Capitalize = false;
options.XOffset = -.06;
options.YOffset = .01;
options.FontSize = 20;
options.FontWeight = 'bold';
options.DeleteAll = false;
options.ColumnFirst = false;
options.IgnoreThese = [];

if ~nargin && nargout == 1
	varargout{1} = options;
	return
end

options = corelib.parseNameValueArguments(options, varargin{:});

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

if options.DeleteAll
	return
end


% get all the axes from the current figure
axesHandles = [findall(gcf,'type','polaraxes'); findall(gcf,'type','axes')];


% ignore specified handles
rm_this = false(length(axesHandles),1);
for i = 1:length(options.IgnoreThese)
	rm_this(options.IgnoreThese(i) == axesHandles) = true;
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
if options.ColumnFirst
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
if options.Capitalize
	for i = length(axesHandles):-1:1
		L{i} = char(64+i);
	end
else
	for i = length(axesHandles):-1:1
		L{i} = char(96+i);
	end
end

for i = length(axesHandles):-1:1
	label_handles(i) = axlib.label(axesHandles(i),L{i},options);
	uistack(label_handles(i),'top')
end

if nargout == 2
	varargout{2} = label_handles;
end