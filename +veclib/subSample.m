% subsample a vector intelligently, applying a 
% function to each chunk

function Y = subSample(X, N, func_handle)

if nargin == 2
	func_handle = @max;
end

assert(isvector(X),'X must be a vector')
X = X(:);

X_chunks = veclib.chunk(X,N);

Y = NaN(size(X_chunks,2),1);

for i = 1:size(X_chunks,2)
	Y(i) = func_handle(X_chunks(:,i));
end
