%% findTimeSinceThresholdCrossing
% finds the time since a time series crosses a threshold, along the time series 
% usage:
% 
% time_since_thresh_crossing = findTimeSinceThresholdCrossing(X,threshold)
% where X is a vector
% and threshold is the threshold 

function time_since_thresh_crossing = findTimeSinceThresholdCrossing(X,threshold)

if ~nargin
	help findTimeSinceThresholdCrossing
	return
end

assert(isvector(X),'first argument should be a vector')

X = X(:);

% make the outputs
time_since_thresh_crossing = NaN*X;

x = X > threshold;

for i = 2:length(X)
	temp = find(x(1:i-1),1,'last');
	if ~isempty(temp)
		time_since_thresh_crossing(i) = i - temp;
	end
end