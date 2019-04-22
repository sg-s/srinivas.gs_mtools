% measures the distance between pairs of ISI sets
% 
function D = ISIDistance(X, Y)


if nargin == 1

	% compute a square matrix of distances
	% assume that the input contains different rows
	% of ISIS, and we want all pairwise distances

	N = size(X,2);

	D = NaN(N);

	if N > 300
		parfor i = 1:N

			D(:,i) = neurolib.internal.ISI_parallel(X,i);
		end
	else
		for i = 1:N

			D(:,i) = neurolib.internal.ISI_parallel(X,i);
		end
	end


else


	% assume that we want to compute distances between two sets of 
	% differnet ISIs

	N_X = size(X,2);
	N_Y = size(Y,2);

	D = NaN(N_X,N_Y);

	parfor i = 1:N_X
		D(i,:) = neurolib.internal.ISI_parallel2(X(:,i),Y);
	end

end