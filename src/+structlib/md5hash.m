% function that hashes a structure
% using hashlib.md5hash
%
function H = md5hash(S)

if isempty(S)
	H = hashlib.md5hash(S);
	return
end

assert(isstruct(S),'Input must be a structure')

S = S(:);
if length(S) > 1

	H = cell(length(S),1);

	for i = 1:length(S)
		H{i} = structlib.md5hash(S(i));
	end

	H = hashlib.md5hash([H{:}]);

	return

end


S = orderfields(S);

fn = fieldnames(S);

if length(fn) == 0
	H = hashlib.md5hash([]);
	return
end

for i = length(fn):-1:1
	this_field = S.(fn{i});

	if iscategorical(this_field)
		this_field = corelib.categorical2cell(this_field);
	end

	if iscell(this_field)
		this_field = this_field(:);
		this_field = [this_field{:}];
	end

	if isstruct(this_field)
		H{i} = structlib.md5hash(this_field);
	else
		H{i} = hashlib.md5hash(this_field);
	end

	
end


H = hashlib.md5hash([H{:}]);
