% plots a trajectory with arrows in 2D space 


function [ph, arrows] = trajectory(varargin)


options.NArrows = 3;
options.ArrowSize = 3;
options.LineWidth = .5;
options.Color = 'k';
options.LogX = true;
options.LogY = true;
options.NormX = true;
options.NormY = true;
options.ArrowAngle = 30; % degrees
options.ArrowLength = .1;
options.TerminalArrow = true;
options.MinTrajLength = .01;
options.LineStyle = '-';


[ax, varargin] = axlib.grabAxHandleFromArguments(varargin{:});

xx = varargin{1};
yy = varargin{2};
varargin(1:2) = [];


assert(~any(isnan(xx)),'NaNs detected in inputs, cannot continue')
assert(~any(isnan(yy)),'NaNs detected in inputs, cannot continue')

options = corelib.parseNameValueArguments(options,varargin{:});

assert(isvector(xx),'xx must be a vector')
assert(isvector(yy),'yy must be a vector')

xx = xx(:);
yy = yy(:);

assert(length(xx) == length(yy),'xx and yy must be of equal lengths')

ph = plot(ax,xx,yy,'LineWidth',options.LineWidth,'Color',options.Color,'LineStyle',options.LineStyle);
hold on


% normalize xx and yy 
if options.NormX
	XLim = [min(xx) max(xx)];
else
	XLim = ax.XLim;
end

if options.NormY
	YLim = [min(yy) max(yy)];
else
	YLim = ax.YLim;
end


if diff(XLim) > eps & diff(YLim) > eps
	xx = plotlib.normalize(xx,XLim,options.LogX);
	yy = plotlib.normalize(yy,YLim,options.LogY);
	heading = atan2(diff(yy),diff(xx));

elseif diff(XLim) > eps & ~(diff(YLim) > eps)
	% horizontal line

	xx = plotlib.normalize(xx,XLim,options.LogX);
	if xx(1) > xx(end)
		heading = 0*xx;
	else
		heading = (pi)*(1 + 0*xx);
	end

elseif diff(YLim) > eps & ~(diff(XLim) > eps)
	% vertical line
	yy = plotlib.normalize(yy,YLim,options.LogY);
	if yy(1) > yy(end)
		heading = (3*pi/2)*(1 + 0*yy);
	else
		heading = (pi/2)*(1 + 0*yy);
	end
	

else
	ph = [];
	arrows = [];
	return

end




% compute cumulative distance along line 
D = geomlib.pathlength(xx,yy);


% should we plot an arrow? only do so if it's long enough
if D(end) < options.MinTrajLength
	return
end

% find points to put arrows in
arrow_spacing = D(end)/(options.NArrows+1);



% if only one arrow is requested, put that arrow at the end of the line
if options.NArrows == 1 && options.TerminalArrow
	arrow_spacing = D(end-2);

	% use an average heading
	heading(:) =  mean(heading(ceil(length(heading)/2):end));

end


for i = 1:options.NArrows
	idx = find(D>arrow_spacing*i,1,'first');



	orientation = rad2deg(heading(idx));

	b(1) = yy(idx) - options.ArrowLength*sin(deg2rad(orientation - options.ArrowAngle));
	a(1) = xx(idx) - options.ArrowLength*cos(deg2rad(orientation - options.ArrowAngle));


	b(2) = yy(idx) - options.ArrowLength*sin(deg2rad(orientation + options.ArrowAngle));
	a(2) = xx(idx) - options.ArrowLength*cos(deg2rad(orientation + options.ArrowAngle));

	if diff(XLim) > eps & diff(YLim) > eps

		% normal
		this_x = plotlib.deNormalize([xx(idx) a(1)], XLim, options.LogX);
		this_y = plotlib.deNormalize([yy(idx) b(1)], YLim, options.LogY);


		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

		this_x = plotlib.deNormalize([xx(idx) a(2)], XLim, options.LogX);
		this_y = plotlib.deNormalize([yy(idx) b(2)], YLim, options.LogY);


		arrows(i,2) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);



	elseif diff(XLim) > eps & ~(diff(YLim) > eps)
		% horizontal line
		

		this_x = plotlib.deNormalize([xx(idx) a(1)], XLim, options.LogX);
		this_y = plotlib.deNormalize([yy(idx) b(1)], YLim, options.LogY);

		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

	elseif diff(YLim) > eps & ~(diff(XLim) > eps)
		% vertical line

		this_x = plotlib.deNormalize([xx(idx) a(1)], XLim, options.LogX);
		this_y = plotlib.deNormalize([yy(idx) b(1)], YLim, options.LogY);


		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

	end
end