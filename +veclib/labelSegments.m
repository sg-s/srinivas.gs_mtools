% function that accepts a logical vector
% where 1 represents a switch in some label
% and returns a vector of equal length
% with every element being assigned to a natural number
%
% example:
%
% X = [0 0 1 0 0 1 0 0];
% Y = veclib.labelSegments(X);
% Y will be [1 1 2 2 2 3 3 3];

function labels = labelSegments(X)

arguments
	X (:,1) logical
end


idx = 1;
labels = zeros(length(X),1);
for i = 1:length(X)
	
	if X(i) 
		idx = idx + 1;
	end
	labels(i) = idx;
end