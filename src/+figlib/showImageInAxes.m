% this function fixes the limits and positions 
% of an axes object that contains an image
% whose sole purpose is to show that image
% it does the following things:
% 
% 1. turns the axis off
% 2. matches X and YLims to the size of the image
% 3. matches the real pixel position of the axis
%    to the aspect ratio of the image. 

function showImageInAxes(ax, I)

I = imglib.crop(I, 5);

im = image(ax,I);
im.Interpolation = 'bilinear';

axis(ax,'image')
axis(ax,'off')

% this actually does something--
% it sets the mode to manual so it sticks
ax.XLim = [1 size(I,2)];
ax.YLim = [1 size(I,1)];

ax.YDir = 'reverse';
ax.XDir = 'normal';