% this function finds the *points* at the middle of 
% every edge with non-identical nodes.
% These co-ordinates are returned in BX and BY
%
% it also returns index vectors to map these points
% onto the nodes of the edges they came from
% This can find the points, but will not find lines,
% because you may have disconnected components

function [BX,BY, Nodes] = findCategoryEdges(self, make_plot)

if ~iscategorical(self.data.values)
	error('Cannot compute boundaries when output is non-categorical')
end

warning('off','MATLAB:polyshape:repairedBySimplify')

if nargin < 2
	make_plot = false;
end

[X,Y] = self.normalize;

DT = delaunayTriangulation(X,Y);


% find all edges
E = edges(DT);
BX = NaN(size(E,1),1);
BY = BX;

% stores logical array of which edge nodes go into which point
Nodes = NaN(size(E,1),2);

for i = 1:size(E,1)
	if length(unique(self.data.values(E(i,:)))) == 1
		continue
	end
	BX(i) = mean(X(E(i,:)));
	BY(i) = mean(Y(E(i,:)));

	Nodes(i,:) = E(i,:);


end


rm_this = isnan(BX) | isnan(BY);
BX(rm_this) = [];
BY(rm_this) = [];
Nodes(rm_this,:) = [];

% denormalize
[BX,BY] = self.denormalize(BX,BY);

