% checks if all inputs have the same size
% useful in validation of arguments

function TF = isSameSize(varargin)

TF = false;

SZ = size(varargin{1});

for i = 2:length(varargin)
	this_SZ = size(varargin{i});

	if numel(SZ) ~= numel(this_SZ)
		return
	end

	if ~all(SZ == this_SZ)
		return
	end

end

TF = true;