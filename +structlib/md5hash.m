% function that hashes a structure
% using hashlib.md5hash
%
function H = md5hash(S)

assert(isstruct(S),'Input must be a structure')
assert(isscalar(S),'Input must be a scalar structure')



fn = fieldnames(S);

for i = length(fn):-1:1
	this_field = S.(fn{i});

	if iscategorical(this_field)
		this_field = corelib.categorical2cell(this_field);
	end

	if iscell(this_field)
		this_field = this_field(:);
		this_field = [this_field{:}];
	end

	H{i} = hashlib.md5hash(this_field);
end

H = hashlib.md5hash([H{:}]);