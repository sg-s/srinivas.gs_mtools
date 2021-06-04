% when possible, converts a scalar structure
% into an array
function [X, fn] = vectorise(S)

assert(isstruct(S),'S must be a struct')
assert(length(S) == 1, 'S must be a scalar')


fn = sort(fieldnames(S));

X = NaN(length(fn),1);

for i = 1:length(fn)
	if isscalar(S.(fn{i}))
		X(i) = S.(fn{i});
	end
end