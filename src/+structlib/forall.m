% set thing for all fields
% 
function forall(S, Name, Value )

arguments
	S (1,1) struct
	Name (1,1) string
	Value
end

fn = fieldnames(S);

for i = 1:length(fn)
	S.(fn{i}).(Name) = Value;
end