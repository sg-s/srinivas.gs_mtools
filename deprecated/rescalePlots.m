%% rescalePlots.m
% rescales all plots in a axes
% subtracting a baseline, and dividing by the peak in a window
% usage:
% rescalePlots(ax,baseline_window,peak_window)
% where ax is the axes you want to operate on
% baseline_window is a 2-element vector specifying the indices that define the baseline
% and peak_window is a 2-element vector specifying the indices that define the peak
% 
% you can also use:
% rescalePlots(baseline_window,peak_window)
% WARNING: rescalePlots irreversibly changes data on the plot, so use with care
% 
function [] = rescalePlots(varargin)

if ~nargin
	help rescalePlots
	return
end

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1)= [];
else
	ax = gca;
end

baseline_window = varargin{1};
peak_window = varargin{2};


% get all plots
p = get(ax,'Children');

for i = 1:length(p)
	y = p(i).YData;

	% rescale
	y = y - nanmean(y(baseline_window(1):baseline_window(2)));
	y = y/nanmax(y(peak_window(1):peak_window(2)));
	p(i).YData = y;
end

set(ax,'YLim',[0 1])
