% makes a structure
function S = make(varargin)

N = 1;

N_idx = find(cellfun(@isnumeric,varargin));
if any(N_idx)
	N = varargin{N_idx};
	varargin(N_idx) = [];
end



S = struct();
for i = 1:length(varargin)
	S.(varargin{i}) = [];
end

if N == 1
	return
end

S = repmat(S,N,1);
