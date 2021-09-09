function firstDimensionEqualSize(varargin)

X = cellfun(@(x) size(x,1), varargin);

assert(all(X == X(1)),'Matrices have unequal sizes')