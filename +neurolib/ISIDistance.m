% measures the distance between pairs of ISI sets
% 
function D = ISIDistance(X)

N = size(X,2);

D = NaN(N);



parfor i = 1:N
	D(:,i) = neurolib.internal.ISI_parallel(X,i);
end
