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

ons = computeOnsOffs(X > threshold);
ons = unique([ons; length(X)]);

for i = length(ons):-1:2
	time_since_thresh_crossing(ons(i-1)+1:ons(i)) =  1:(ons(i)-ons(i-1));
end