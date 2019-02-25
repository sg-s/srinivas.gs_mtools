% equalizeAxes
% equalizes axes for multiple subplots in a figure
% usage:
% 
% equalizeAxes() % equalize all X and Y axes in all subplots in current figure
%
% equalizeAxes(fig_handle) % equalize all X and Y axes in all subplots in given figure
%
% equalizeAxes(axes_handles) % equalize all X and Y axes in all subplots in only these axes
% 
% equalizeAxes('x') % equalize all X but not Y axes in all subplots in in current figure
% 
% equalizeAxes('y') % equalize all Y but not X axes in all subplots in in current figure
% 

function [] = equalize(varargin)


% grab figure handle, if it exists 
for i = 1:nargin
	if strcmp(class(varargin{i}),'matlab.ui.figure')
		fig_handle = varargin{i};
		break
	else
		continue
	end
end
if ~exist('fig_handle','var')
	fig_handle = gcf;
end



% grab axes handles, if they exist 
ax_handles = [];
for i = 1:nargin
	if strcmp(class(varargin{i}),'matlab.graphics.axis.Axes')
		ax_handles = [ax_handles varargin{i}];
		break
	else
		continue
	end
end
if isempty(ax_handles)
	ax_handles = fig_handle.Children;
end



eq_x = false;
eq_y = false;
eq_z = false;
for i = 1:nargin
	if strcmp(varargin{i},'x')
		eq_y = true;
	end
	if strcmp(varargin{i},'y')
		eq_x = true;
	end
	if strcmp(varargin{i},'z')
		eq_z = true;
	end
end

if ~eq_x & ~eq_y & ~eq_z
	% equalize nothing doesn't make sense. so let's equalize everything
	eq_x = true;
	eq_y = true;
	eq_z = true;
end

if eq_x
	xlims = reshape([ax_handles.XLim],2,length(ax_handles));
	min_x = min(xlims(1,:));
	max_x = max(xlims(2,:));

	for i = 1:length(ax_handles)
		ax_handles(i).XLim = [min_x max_x];
	end
end

if eq_y
	ylims = reshape([ax_handles.YLim],2,length(ax_handles));
	min_y = min(ylims(1,:));
	max_y = max(ylims(2,:));

	for i = 1:length(ax_handles)
		ax_handles(i).YLim = [min_y max_y];
	end
end

if eq_z
	zlims = reshape([ax_handles.ZLim],2,length(ax_handles));
	min_z = min(zlims(1,:));
	max_z = max(zlims(2,:));

	for i = 1:length(ax_handles)
		ax_handles(i).ZLim = [min_z max_z];
	end
end

