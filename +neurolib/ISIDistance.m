% wrapper function to compute distances between ISI
% sets given by X and Y
%
% Usage:
% D = neurolib.ISIDistance(X,Y,1);
% D = neurolib.ISIDistance(X,[],1);
function D = ISIDistance(X, Y, Variant)




assert(nargin == 3,['3 arguments required. If you want to compute all distances between all observations, specify "Y=[]". A correct usage is' newline  newline 'neurolib.ISIDistance(X,Y,Variant)'])

cpp_file = [fileparts(which('neurolib.ISIDistance')) filesep '+internal' filesep 'ISIDistance.cpp'];

% check that binary is up-to-date
corelib.compile(cpp_file);


% clean data
X(isinf(X)) = NaN;
if isempty(Y)
	Y(isinf(Y)) = NaN;
end


% sort all rows
N_X = size(X,2);
for i = 1:N_X
	X(:,i) = sort(X(:,i));
end

if isempty(Y)

	% compute a square matrix of distances
	% assume that the input contains different rows
	% of ISIS, and we want all pairwise distances


	D = NaN(N_X);

	if N_X > 300
		parfor i = 1:N_X
			D(:,i) = neurolib.internal.ISI_parallel(X,i,Variant);
		end
	else
		for i = 1:N_X
			D(:,i) = neurolib.internal.ISI_parallel(X,i,Variant);
		end
	end


else

	N_Y = size(Y,2);

	% sort all rows
	for i = 1:N_Y
		Y(:,i) = sort(Y(:,i));
	end


	% assume that we want to compute distances between two sets of 
	% different ISIs


	D = NaN(N_X,N_Y);

	parfor i = 1:N_X
		D(i,:) = neurolib.internal.ISI_parallel2(X(:,i),Y,Variant);
	end

end