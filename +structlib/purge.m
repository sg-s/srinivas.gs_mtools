% purges a subset of matrices in a structure
% using a logical index

function S = purge(S, rm_this)

assert(isstruct(S),'S must be a structure')
assert(isscalar(S),'S must be scalar')
assert(isvector(rm_this),'rm_this must be a logical vector')
assert(islogical(rm_this),'rm_this must be a logical vector')
fn = fieldnames(S);

Size = length(rm_this);
for i = 1:length(fn)
	assert(size(S.(fn{i}),1) == Size,'Size mismatch between rm_this and S')
end

for i = 1:length(fn)
	S.(fn{i})(rm_this,:,:,:,:) = [];
end
