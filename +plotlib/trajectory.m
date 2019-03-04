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
XLim = [min(xx) max(xx)];
YLim = [min(yy) max(yy)];
[xx,yy] = plotlib.normalize(xx,yy,XLim,YLim,options.log_x,options.log_y);


% compute heading
heading = atan2(diff(yy),diff(xx));


% compute cumulative distance along line 
D = (xx(2:end) - xx(1:end-1)).^2 + (yy(2:end) - yy(1:end-1)).^2;
D = sqrt(D); D = D(:);
D = cumsum([0; D]);


% find points to put arrows in
arrow_spacing = D(end)/(options.n_arrows + 2);



for i = 1:options.n_arrows
	idx = find(D>arrow_spacing*i,1,'first');


	orientation = rad2deg(heading(idx));
	centre = [xx(idx) yy(idx)];

	c2a = 3*options.size; % centre to apex distance
	c2b = options.size; % centre to base distance

	%% calculate points
	% apex
	apex(1) = centre(1) + c2a*cosd(orientation);
	apex(2) = centre(2) + c2a*sind(orientation);

	% base
	base(1) = centre(1) - c2b*cosd(orientation);
	base(2) = centre(2) - c2b*sind(orientation);

	% left and right points
	left(1) = base(1) - c2b*sind(orientation);
	left(2) = base(2) + c2b*cosd(orientation);

	right(1) = base(1) + c2b*sind(orientation);
	right(2) = base(2) - c2b*cosd(orientation);


	[this_x, this_y] = plotlib.deNormalize([apex(1) left(1)],[apex(2) left(2)], XLim, YLim, options.log_x, options.log_y);

	arrows(i,1) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

	[this_x, this_y] = plotlib.deNormalize([apex(1) right(1)],[apex(2) right(2)], XLim, YLim, options.log_x, options.log_y);
	arrows(i,2) = line(ax,this_x,this_y,'Color',options.Color,'LineWidth',options.LineWidth);

end