% a fast error-shading plot function
% 
% usage:
% plotlib.errorShade(gca, Y)
% plotlib.errorShade(gca, X, Y, E)
% plotlib.errorShade(gca, X, Y, E, 'Shading',.6)
% plotlib.errorShade(gca, X, Y, E, 'Color',[1 0 0])
% plotlib.errorShade(gca, X, Y, E, 'LineWidth',2)
% plotlib.errorShade(gca, X, Y, E, 'SubSample',10)

function [line_handle, shade_handle] = errorShade(ax, x, y, e, options)


arguments
	ax (1,1) matlab.graphics.axis.Axes
	x (:,1) double
	y (:,1) double = []
	e (:,1) double = []
	options.Shading = .6
	options.Color = [1 0 0]
	options.LineWidth = 2
	options.SubSample = 1 
end

if ~nargin
    help plotlib.errorShade
    return
end


if isempty(y) and isempty(e)
	keyboard
end


assert(length(x)==length(y),'All inputs must have the same length')
assert(length(x)==length(e),'All inputs must have the same length')



% subsample
options.SubSample = ceil(options.SubSample);
x = x(1:options.SubSample:end);
y = y(1:options.SubSample:end);
e = e(1:options.SubSample:end);

if length(x) < 1e2
	% fall back to shadedErrorBar
	axes(ax)
	h = plotlib.shadedErrorBar(x,y,e,{'Color',options.Color,'LineWidth',options.LineWidth});
	line_handle = [h.mainLine h.edge(1) h.edge(2)];
	shade_handle = h.patch;
	set(line_handle,'LineWidth',options.LineWidth);
else
	% first plot the error
	ee = [y-e y+e NaN*e]';
	xe = [x x NaN*(x)]';
	ee = ee(:);
	xe = xe(:);
	shade_handle = plot(ax,xe,ee,'Color',[options.Color + options.Shading*(1- options.Color)]);


	% now plot the plot
	line_handle = plot(ax,x,y,'Color',options.Color,'LineWidth',options.LineWidth);
end

