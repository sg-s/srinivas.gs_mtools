% mtools.vector.pickN
% 
% picks N elements from a vector
% this is guaranteed to return N
% elements, no longer how long or short the input vector is
% 
% if X is more than N elements long, it picks N uniformly
% spaced points
% if X is less than N elements long, it returns X and NaN pads it
% 
function Y = pickN(X, N)

if isempty(X)
	Y = NaN(N,1);
	return
end

assert(isvector(X), 'First argument should be a vector')
X = X(:);

if length(X) > N
	D = floor(length(X)/N);
	Y = X(1:D:end);
else
	Y = NaN(N,1);
	Y(1:length(X)) = X;
end