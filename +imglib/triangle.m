% draws a equliateral triangle at a given point and orientation
% so that it points towards the orientation and its centroid is located at the point. useful for building GUIs
% 
% created by Srinivas Gorur-Shandilya at 18:58 , 30 August 2013. Contact me
% at http://srinivas.gs/contact/
function triangle(centre,orientation,varargin)




options.LineWidth = 1;
options.draw_base = true;
options.Color = 'k';
options.size = 1;

options = corelib.parseNameValueArguments(options,varargin{:});

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

%% draw the triangle
hold on
line([apex(1) left(1)],[apex(2) left(2)],'Color',options.Color,'LineWidth',options.LineWidth)
line([apex(1) right(1)],[apex(2) right(2)],'Color',options.Color,'LineWidth',options.LineWidth)

if options.draw_base
	line([right(1) left(1)],[right(2) left(2)],'Color',options.Color,'LineWidth',options.LineWidth)
end

