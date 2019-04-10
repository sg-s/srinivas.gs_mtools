% makes a square matrix symmetric about the 
% diagonal, no matter what

function M = symmetrize(X)

assert(ismatrix(X),'input must be a matrix')
assert(size(X,1)==size(X,2),'input must be a square matrix')

M = max(cat(3,X,tril(X)'),[],3);