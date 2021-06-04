% purges a subset of matrices in a structure
% using a logical index

function S = purge(S, rm_this)

arguments
	S (1,1) struct
	rm_this (:,1) logical

end


fn = fieldnames(S);

Size = length(rm_this);
for i = 1:length(fn)
	assert(size(S.(fn{i}),1) == Size,'Size mismatch between rm_this and S')
end

for i = 1:length(fn)
	S.(fn{i})(rm_this,:,:,:,:) = [];
end
