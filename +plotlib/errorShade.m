% a fast error-shading plot function
% 
% usage:
% plotlib.errorShade(X)
% plotlib.errorShade(gca, X)
% plotlib.errorShade(gca, X, Y, E)
% plotlib.errorShade(gca, X, Y, E, 'Shading',.6)
% plotlib.errorShade(gca, X, Y, E, 'Color',[1 0 0])
% plotlib.errorShade(gca, X, Y, E, 'LineWidth',2)
% plotlib.errorShade(gca, X, Y, E, 'SubSample',10)

function [line_handle, shade_handle] = errorShade(varargin)


if ~nargin
    help plotlib.errorShade
    return
end

% parse inputs
if ishandle(varargin{1})
	h = varargin{1};
	varargin(1) = [];
else
	h = gca; % create a new axes if needed
end

hold(h,'on');


switch length(varargin) 

case 1
	y = varargin{1};
	x = 1:size(y,2);
	e = corelib.sem(y);
	y = nanmean(y);
	varargin(1) = [];
case 2
	x = varargin{1};
	y = varargin{2};
	e = corelib.sem(y);
	y = nanmean(y);
	varargin(1:2) = [];
case 3
	x = varargin{1};
	y = varargin{2};
	e = varargin{3};
	varargin(1:3) = [];

end


% defensive programming
if isempty(x)
	x = 1:length(y);
	x = x(:);
end


assert(length(x)==length(y),'All inputs must have the same length')
assert(length(x)==length(e),'All inputs must have the same length')

% defaults
options.Shading = .75;
options.Color = [1 0 0];
options.LineWidth = 1;
options.SubSample = 1;

options = corelib.parseNameValueArguments(options, varargin{:});

% subsample
options.SubSample = ceil(options.SubSample);
x = x(1:options.SubSample:end);
y = y(1:options.SubSample:end);
e = e(1:options.SubSample:end);

if length(x) < 1e3
	% fall back to shadedErrorBar
	axes(h);
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
	shade_handle = plot(h,xe,ee,'Color',[options.Color + options.Shading*(1- options.Color)]);


	% now plot the plot
	line_handle = plot(h,x,y,'Color',options.Color,'LineWidth',options.LineWidth);
end

