% chunks a vector into a matrix, even
% if reshape fails because the vector is 
% weirdly sized
% 
% usage:
%
% Y = veclib.chunk(X,ChunkSize)


function Y = chunk(X, ChunkSize)

arguments
	X (:,1) double
	ChunkSize (1,1) double {mustBeInteger, mustBePositive}
end


X = X(:);

n_rows = length(X)/ChunkSize;

if n_rows == round(n_rows)
	% all good. just use reshape
else
	n_rows = floor(n_rows);
	X = X(1:n_rows*ChunkSize);

end

Y = reshape(X,ChunkSize,n_rows);