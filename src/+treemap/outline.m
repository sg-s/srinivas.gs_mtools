function outline(rectangles)
    %OUTLINE  Outline in black all the rectangles
    %   outline(rectangles)
    %   rectangles is a 4-by-N matrix where each column is a rectangle in
    %   the form [x0,y0,w,h]. x0 and y0 are the coordinates of the lower
    %   left-most point in the rectangle.
    %
    %   Example:
    %    cla
    %    outline([0 0 1 1; 1 0 1 1; 0 1 2 1]')
    %
    %   Copyright 2007-2013 The MathWorks, Inc.
    %
    %   See also PLOTRECTANGLES. 
    
    for i = 1:size(rectangles,2)
        r = rectangles(:,i);
        xPoints = [r(1),      r(1), r(1)+r(3), r(1)+r(3)];
        yPoints = [r(2), r(2)+r(4), r(2)+r(4), r(2)     ];
        patch(xPoints,yPoints,[0 0 0],'FaceColor','none')
    end
end