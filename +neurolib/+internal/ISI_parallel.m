function D = ISI_parallel(X,i)


A = X(:,i);
N = size(X,2);

D = zeros(N,1);

for j = i+1:N
	B = X(:,j);
	D(j) = neurolib.internal.ISIDistance(A,B);
end
