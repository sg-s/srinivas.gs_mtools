%% distanceFromLineToPoint.m
% computes distances from a line segment L to a set of points P
% The format of the line segment is L = [x1 y1; x2 y2];
% and the format of the points are P = [x1 y1; x2 y2; ... xN; yN];
% usage: [D] = distanceFromLineToPoint(L,P)
% where D is a vector with positive scalars as long as P
% this works only in 2 dimensions 
% 
function D = distanceFromLineToPoint(L,P)

if size(P,1) > 1
	D = NaN(size(P,1),1);
	for i = 1:size(P,1)
		D(i) = distanceFromLineToPoint(L,P(i,:));
	end
	return
end

x1 = L(1,1);
x2 = L(2,1);
y1 = L(1,2);
y2 = L(2,2);

x0 = P(1);
y0 = P(2);

D = abs((x2 - x1)*(y1 - y0) - (x1 - x0)*(y2 - y1));
D = D/(sqrt((x2 - x1).^2 + (y2 - y1).^2));