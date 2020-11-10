% subsample a vector intelligently, applying a 
% function to each chunk

function Y = subSample(X, N, func_handle)

arguments
	X (:,1) double 
	N (1,1) double 
	func_handle (1,1) function_handle 
end

X_chunks = veclib.chunk(X,N);

Y = NaN(size(X_chunks,2),1);

for i = 1:size(X_chunks,2)
	Y(i) = func_handle(X_chunks(:,i));
end
