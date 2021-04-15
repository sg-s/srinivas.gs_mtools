function S = trim(S,N)


fn = fieldnames(S);
for i = 1:length(fn)
	S.(fn{i}) = S.(fn{i})(1:N);
end