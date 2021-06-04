% converts a cell array of structs, with potentially different
% fields, to an array of structs
% 
function N = cell2array(S)

assert(iscell(S),'Expected input argument to be a struct')

assert(length(S) > 1, 'Expected a cell array.')

% vectorise 
S = S(:);


% check that every element is a struct
for i = 1:length(S)
	assert(isstruct(S{i}),'Expected element of cell array to be a struct')
end

allfn = {};
for i = 1:length(S)
	allfn = unique([allfn; fieldnames(S{i})]);

end


N = struct();
for i = 1:length(allfn)
	N.(allfn{i}) = [];
end

for i = 1:length(S)
	for j = 1:length(allfn)
		if isfield(S{i},allfn{j})
			N(i).(allfn{j}) = S{i}.(allfn{j});
		end
	end
end