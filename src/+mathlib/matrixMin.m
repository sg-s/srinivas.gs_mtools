% returns the minimum of a matrix, together with the array index
% of the minimum
% 
% usage:
% [m,a,b] = matrixMin(X)
% 
% where X is a matrix
% m is the minimum of the matrix X
% and m = X(a,b)
%

function [m,a,b] = matrixMin(X)
[m,idx] = min(X(:));
[a,b] = ind2sub(size(X),idx);