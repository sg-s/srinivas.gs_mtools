% Find closest point of a vector to some value
% finds the index ofa vector that is closest to some value
% 
% usage:
% idx = closest([0, 1, 2.01, 3, 4],2); % returns 3
% 
function idx = closest(vec, value)


assert(isvector(vec),'first argument should be a vector')
vec = vec(:);

if length(value) > 1
	value = value(:);
	idx = NaN*value;
	for i = 1:length(value)
		idx(i) = corelib.closest(vec,value(i));
	end
	return
end

[~,idx] = min(abs(vec - value));