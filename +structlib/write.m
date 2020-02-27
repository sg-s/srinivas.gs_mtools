% write nested field from a structure
% 
function X = write(S,F, value)

assert(isstruct(S),'First argument should be a struct')
assert(ischar(F),'Second argument should be a character vector')

F = strsplit(F,'.');
SR = struct;
for i = 1:length(F)
	SR(i).subs = F{i};
	SR(i).type = '.';
end

X = subsasgn(S,SR, value);