% picks N elements from a vector
% this is guaranteed to return N
% elements, no longer how long or short the input vector is
% 
% if X is more than N elements long, it picks N uniformly
% spaced points
% if X is less than N elements long, it returns X and NaN pads it
% 
function Y = pickN(X, N, where_from)

if isempty(X)
	Y = NaN(N,1);
	return
end

assert(N > 0,'N must be a positive number')
assert(mathlib.iswhole(N),'N must be an integer')
assert(isvector(X), 'First argument should be a vector')
X = X(:);

if nargin < 3
	where_from = 'uniform';
end

if length(X) > N

	switch where_from
	case 'uniform'

		D = floor(length(X)/N);
		if D == length(X)/N
			% all OK
			Y = X(1:D:end);
			return
		else
			% sample randomly, since it's not possible
			% to get grid points here
			idx = randperm(length(X));
			idx = sort(idx(1:N));
			Y = X(idx);
			return
		end

	case 'first'
		Y = X(1:N);
	case 'last'
		Y = X(end-N+1:end);
	end


	
else
	Y = NaN(N,1);
	Y(1:length(X)) = X;
end