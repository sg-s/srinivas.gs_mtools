%% shuffle.m
% shuffles a vector or a matrix
% usage:
% 
% X = shuffle(X);
% if X is a matrix,
% X is shuffled along the longer dimension, for each element in the shorter dimension

function XS = shuffle(X)

if isvector(X)
	assert(isvector(X),'Argument must be a vector');
	XS = X(randperm(length(X)));
	return
else
	sz = size(X);
	flip = false;
	if sz(2) > sz(1)
		sz = sz';
		flip = true;
	end
	sz = size(X);
	for i = 1:sz(2)
		XS(:,i) = shuffle(X(:,i));
	end
	if flip
		XS = XS';
	end
end

