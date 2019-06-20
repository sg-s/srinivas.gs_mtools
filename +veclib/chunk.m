% chunks a vector into a matrix, even
% if reshape fails because the vector is 
% weirdly sized
% 
% usage:
%
% Y = veclib.chunk(X,ChunkSize)


function Y = chunk(X, ChunkSize)

assert(isvector(X),'X must be a vector')
assert(isnumeric(X),'X must be a vector')

assert(length(ChunkSize) == 1,'ChunkSize must be a scalar integer')
assert(isnumeric(ChunkSize),'ChunkSize must be a scalar integer')
assert(ChunkSize > 0,'ChunkSize must be a scalar integer')
assert(ChunkSize == round(ChunkSize),'ChunkSize == round(ChunkSize)')

X = X(:);

n_rows = length(X)/ChunkSize;

if n_rows == round(n_rows)
	% all good. just use reshape
else
	n_rows = floor(n_rows);
	X = X(1:n_rows*ChunkSize);

end

Y = reshape(X,ChunkSize,n_rows);