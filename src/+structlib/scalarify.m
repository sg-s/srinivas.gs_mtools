% accepts a vector of structures and repacks
% all data so that it is a scalar structure
% with giant matrices inside

function X = scalarify(S)

assert(isstruct(S),'S must be a structure')
assert(length(S)>1,'S must be a vector of structs')


X = struct;
fn = fieldnames(S);

for i = 1:length(fn)


	try

		X.(fn{i}) = cat(2,S.(fn{i}));
	catch
		X.(fn{i}) = cat(1,S.(fn{i}));
	end

	X.(fn{i}) = X.(fn{i})(:);
end