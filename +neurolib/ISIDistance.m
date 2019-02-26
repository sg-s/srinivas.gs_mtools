% measures the distance between pairs of ISI sets
% 
function D = ISIDistance(X)

N = size(X,2);

D = NaN(N);

if N > 1e3

	parfor i = 1:N
		D(:,i) = neurolib.internal.ISI_parallel(X,i);
	end


else
	for i = 1:N
		D(:,i) = neurolib.internal.ISI_parallel(X,i);
	end
end