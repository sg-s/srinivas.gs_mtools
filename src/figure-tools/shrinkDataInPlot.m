%% shrinkDataInPlot
% custom compression engine that selectively throws away points in a plot to keep them visually identical, but much smaller in size
% use this to make EPS figures that are crisp but small
% usage:
% shrinkDataInPlot(handle_to_plot_object,distance_to_next_point)
% handle_to_plot_object can be a handle to a line object
% or it can be a handle to a whole axis. 
%
% distance_to_next_point is the distance from one data point to the next, in pixels
% if you increase this, your plot will get smaller, but less accurate. 
% a good starting value is distance_to_next_point = 1
%
% WARNING: 
% shrinkDataInPlot irreversibly alters data on your plot. You will have to redo your plot if you want to undo changes.
% 
% part of mtools, which lives here:
% https://github.com/sg-s/srinivas.gs_mtools


function [] = shrinkDataInPlot(handle_to_plot_object,distance_to_next_point)

if ~nargin
	help shrinkDataInPlot
	return
end

if isa(handle_to_plot_object,'matlab.graphics.axis.Axes')
	temp = handle_to_plot_object.Children;
	for i = 1:length(temp)
		shrinkDataInPlot(temp(i),distance_to_next_point);
	end
	return
end


% translation layer
c = handle_to_plot_object;

x_range = abs(diff(c.Parent.XLim));
y_range = abs(diff(c.Parent.YLim));
x_size = (c.Parent.Position(3));
y_size = (c.Parent.Position(4));

% get data
x = get(c,'XData');
y = get(c,'YData');

% crop to viewport
disp('Cropping to viewport...')
xlim = c.Parent.XLim; ylim = c.Parent.YLim;
rm_this = x < xlim(1) | x > xlim(2) | y < ylim(1) | y > ylim(2);
x(rm_this) = [];
y(rm_this) = [];

c.XData = x;
c.YData = y;
try
	c.CData(rm_this,:) = [];
catch
end

% convert x and y data into physical units
if strcmp(c.Parent.XScale,'log')
	%error('Log plots not supported')
	assert(min(x)>0,'Negative values on log plot, fatal error')
	x = log(x);
	x_range = log(x_range);
end
if strcmp(c.Parent.YScale,'log')
	%error('Log plots not supported')
	assert(min(y)>0,'Negative values on log plot, fatal error')
	y = log(y);
	y_range = log(y_range);
end
raw_x = x; raw_y = y;
fig_width = c.Parent.Parent.Position(3);
fig_height = c.Parent.Parent.Position(4);
x = (x./x_range)*x_size*fig_width;
y = (y./y_range)*y_size*fig_height; % x and y now in pixels

if length(x) < 500
	disp('<500 points; returning without optimisation.')
	return
end


% sub-sample data based on desired dots/pixel. to do this, we iteratively build the timeseries, accepting points only if they are sufficiently far away in real space
xx = NaN*x; yy = NaN*y; this_pt_index = 1;
xx(1) = x(1); yy(1) = y(1);
disp('Subsampling data....')
while this_pt_index < length(x)

	this_pt = [x(this_pt_index) y(this_pt_index)];

	% find distances in real space to all future data points
	d = sqrt((x(this_pt_index+1:end) - this_pt(1)).^2 + (y(this_pt_index+1:end) - this_pt(2)).^2);

	next_pt = this_pt_index + find(d>distance_to_next_point,1,'first');
	xx(next_pt) = raw_x(next_pt);
	yy(next_pt) = raw_y(next_pt);
	this_pt_index = next_pt;
end
xx(1) = raw_x(1); yy(1) = raw_y(1);

if strcmp(c.Parent.YScale,'log')
	yy = exp(yy);
end
if strcmp(c.Parent.XScale,'log')
	xx = exp(xx);
end

try
	% also shrink the CData
	c.CData(isnan(xx),:) = [];
catch
end

temp = 100 - 100*(sum(~isnan(xx))/sum(~isnan(x)));
disp(['Compressed plot by ' oval(temp) '%'])

xx = nonnans(xx);
yy = nonnans(yy);

set(c,'XData',xx);
set(c,'YData',yy);