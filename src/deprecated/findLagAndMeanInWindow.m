%% findLagAndMeanInWindow
% finds the lag between two vectors X and Y and the mean in a preceding window of length L
% usage:
% %
% [lag, mean_x, max_corr] = findLagAndMeanInWindow(X,Y,L,step_size)
% where X and Y are vectors of equal length
% and L is a integer specifying the window size
% and step_size is the increment to move the window along the x axis
% 
% lag, mean_x and max_corr are vectors as long as X or Y
% 

function [lag, mean_x, max_corr] = findLagAndMeanInWindow(X,Y,L,step_size)

if ~nargin
	help findLagAndMeanInWindow
	return
end

assert(isvector(X),'first argument should be a vector')
assert(isvector(Y),'second argument should be a vector')
assert(isscalar(L) & isint(L), 'third argument should be a integer')
assert(L>200,'the window size should be at least 200 samples')
assert(length(X) == length(Y),'first two arguments should have the same length')
assert(length(X) > L*2,'input vector is too short for this window size')

X = X(:);
Y = Y(:);
L = L(:);

if nargin < 4
	step_size = 1;
end

% use cache
hash = dataHash([X; Y; L; step_size]);
result = cache(hash);
if ~isempty(result)
	lag = result.lag;
	mean_x = result.mean_x;
	max_corr = result.max_corr;
	return
end

% make the outputs
lag = NaN*X;
mean_x = NaN*X;
max_corr = NaN*X;
raw_xcorr = NaN(length(L+1:step_size:length(X)),2*L+1);
c = 1;


for i = L+1:step_size:length(X)
	x = X(i-L:i); y = Y(i-L:i);
	mean_x(i) = mean(x);
	x = x - mean(x); x = x/std(x);
	y = y - mean(y); y = y/std(y);
	xc = xcorr(y,x);
	xc = xc/L;
	raw_xcorr(c,:) = xc;
	[max_corr(i),lag(i)] = max(xc);

	c = c + 1;

end

lag = lag - L;


result.lag = lag;
result.mean_x = mean_x;
result.max_corr = max_corr;
cache(hash,result);