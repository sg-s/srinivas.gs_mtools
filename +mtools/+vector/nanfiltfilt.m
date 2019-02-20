% filtfilt, but works with NaNs
% filling in NaNs using linear interpolation 

function Y = nanfiltfilt(X, filter_size)

assert(isvector(X),'X must be a vector')

X = X(:);

if ~any(isnan(X))
	Y = filtfilt(ones(filter_size,1),filter_size,X);
	return
end

rm_this = isnan(X);

% linearly interpolate
X(rm_this) = interp1(find(~isnan(X)),mtools.vector.nonnans(X),find(isnan(X)));

Y = filtfilt(ones(filter_size,1),filter_size,X);
