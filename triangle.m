% triangle.m
% triangle.m draws a equliateral triangle at a given point and orientation,
% so that it points towards the orientation and its centroid is located at
% the point
% created by Srinivas Gorur-Shandilya at 18:58 , 30 August 2013. Contact me
% at http://srinivas.gs/contact/
function [] = triangle(centre,orientation,size,colour,LineWidth)
%% params
c2a = 3*size; % centre to apex distance
c2b = size; % centre to base distance

if nargin < 5
	LineWidth = 1;
end

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
line([apex(1) left(1)],[apex(2) left(2)],'Color',colour,'LineWidth',LineWidth)
line([apex(1) right(1)],[apex(2) right(2)],'Color',colour,'LineWidth',LineWidth)
line([right(1) left(1)],[right(2) left(2)],'Color',colour,'LineWidth',LineWidth)

