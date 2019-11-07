% this function finds the *points* at the middle of 
% every triangle that has non-identical nodes

function [BX,BY] = findCategoryEdges(self, make_plot)

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
for i = 1:size(E,1)
	if length(unique(self.data.values(E(i,:)))) == 1
		continue
	end
	BX(i) = mean(X(E(i,:)));
	BY(i) = mean(Y(E(i,:)));


end

% denormalize
[BX,BY] = self.denormalize(BX,BY);
