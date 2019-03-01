% returns the value from a data vector X that is at the Pth percentile
% usage
% Y = percentile(X,0.1) % returns data at 10%ile
function [Y] = percentile(X,P)

assert(length(X)>1,'First argument should be a vector')
assert(length(P) == 1, '2nd argument should be a scalar')
assert(P <= 1 & P >= 0, '2nd argument should be between 0 and 1')

X = sort(X(:));
Y = X(floor(length(X)*P));