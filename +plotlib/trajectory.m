% plots a trajectory with arrows in 2D space 


function [ph, arrows] = trajectory(varargin)


options.n_arrows = 3;
options.arrow_size = 3;
options.size = .1;
options.LineWidth = .5;
options.Color = 'k';
options.draw_base = false;
options.log_x = true;
options.log_y = true;
options.norm_x = true;
options.norm_y = true;
options.ArrowAngle = 30; % degrees
options.ArrowLength = .1;

[ax, varargin] = axlib.grabAxHandleFromArguments(varargin{:});

xx = varargin{1};
yy = varargin{2};
varargin(1:2) = [];

options = corelib.parseNameValueArguments(options,varargin{:});

assert(isvector(xx),'xx must be a vector')
assert(isvector(yy),'yy must be a vector')

xx = xx(:);
yy = yy(:);

assert(length(xx) == length(yy),'xx and yy must be of equal lengths')

ph = plot(ax,xx,yy,'LineWidth',options.LineWidth,'Color',options.Color);
hold on

% normalize xx and yy 
if options.norm_x
	XLim = [min(xx) max(xx)];
else
	XLim = ax.XLim;
end

if options.norm_y
	YLim = [min(yy) max(yy)];
else
	YLim = ax.YLim;
end


if diff(XLim) > eps & diff(YLim) > eps
	xx = plotlib.normalize(xx,XLim,options.log_x);
	yy = plotlib.normalize(yy,YLim,options.log_y);
	heading = atan2(diff(yy),diff(xx));

elseif diff(XLim) > eps & ~(diff(YLim) > eps)
	disp('horizontal line, not coded')
	keyboard

elseif diff(YLim) > eps & ~(diff(XLim) > eps)
	% vertical line

	xx = plotlib.normalize(xx,ax.XLim,options.log_x);
	yy = plotlib.normalize(yy,YLim,options.log_y);
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
D = (xx(2:end) - xx(1:end-1)).^2 + (yy(2:end) - yy(1:end-1)).^2;
D = sqrt(D); D = D(:);
D = cumsum([0; D]);


% find points to put arrows in
arrow_spacing = D(end)/(options.n_arrows+1);



for i = 1:options.n_arrows
	idx = find(D>arrow_spacing*i,1,'first');



	orientation = rad2deg(heading(idx));


	b(1) = yy(idx) - options.ArrowLength*sin(deg2rad(orientation - options.ArrowAngle));
	a(1) = xx(idx) - options.ArrowLength*cos(deg2rad(orientation - options.ArrowAngle));


	b(2) = yy(idx) - options.ArrowLength*sin(deg2rad(orientation + options.ArrowAngle));
	a(2) = xx(idx) - options.ArrowLength*cos(deg2rad(orientation + options.ArrowAngle));

	if diff(XLim) > eps & diff(YLim) > eps

		% normal
		this_x = plotlib.deNormalize([xx(idx) a(1)], XLim, options.log_x);
		this_y = plotlib.deNormalize([yy(idx) b(1)], YLim, options.log_y);


		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

		this_x = plotlib.deNormalize([xx(idx) a(2)], XLim, options.log_x);
		this_y = plotlib.deNormalize([yy(idx) b(2)], YLim, options.log_y);


		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);



	elseif diff(XLim) > eps & ~(diff(YLim) > eps)
		disp('horizontal line, not coded')
		keyboard
	elseif diff(YLim) > eps & ~(diff(XLim) > eps)
		% vertical line

		this_x = plotlib.deNormalize([xx(idx) a(1)], XLim, options.log_x);
		this_y = plotlib.deNormalize([yy(idx) b(1)], YLim, options.log_y);


		arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

	end
end