% wrapper function to compute distances between ISI
% sets given by X and Y
%
% Usage:
% D = neurolib.ISIDistance(X,Y,1);
% D = neurolib.ISIDistance(X,[],1);
function D = ISIDistance(X, Y, Variant)




assert(nargin == 3,['3 arguments required. If you want to compute all distances between all observations, specify "Y=[]". A correct usage is' newline  newline 'neurolib.ISIDistance(X,Y,Variant)'])

cpp_file = [fileparts(which('neurolib.ISIDistance')) filesep '+internal' filesep 'ISIDistance' mat2str(Variant) '.cpp'];

% check that binary is up-to-date
corelib.compile(cpp_file);

FuncHandle = str2func(['neurolib.internal.ISIDistance' mat2str(Variant)]);

if isempty(Y)

	% compute a square matrix of distances
	% assume that the input contains different rows
	% of ISIS, and we want all pairwise distances

	N = size(X,2);

	D = NaN(N);

	if N > 300
		parfor i = 1:N
			D(:,i) = neurolib.internal.ISI_parallel(X,i,FuncHandle);
		end
	else
		for i = 1:N
			D(:,i) = neurolib.internal.ISI_parallel(X,i,FuncHandle);
		end
	end


else


	% assume that we want to compute distances between two sets of 
	% different ISIs

	N_X = size(X,2);
	N_Y = size(Y,2);

	D = NaN(N_X,N_Y);

	parfor i = 1:N_X
		D(i,:) = neurolib.internal.ISI_parallel2(X(:,i),Y,FuncHandle);
	end

end