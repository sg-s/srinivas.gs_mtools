% structslice
% slices every field of a structure s according to the 
% logical array idx
% example usage:
% s.A = randn(100,1);
% s.B = randn(100,1);
% new_s = structslice(s,randn(100,1) > 0);
% 
% limitations:
% only 1 D slices are supported for now, though the individual
% fields may be up to 8-dimensional 

function s = structslice(s,idx)

assert(isstruct(s),'First argument should be a structure')
assert(islogical(idx),'Second argument should be a logical array')

fn = fieldnames(s);

new_s = s;

for i = 1:length(fn)
	this_field = s.(fn{i});
	sz = size(this_field);
	dim_to_slice = find(sz == length(idx));
	assert(length(dim_to_slice) == 1,'At least one field has the wrong size and cannot be sliced')

	new_s.(fn{i}) = this_field(:,idx,:,:,:,:,:,:,:,:);
end

s = new_s;