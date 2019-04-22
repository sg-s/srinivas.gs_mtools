% autoCorrelationTime.m
% finds the autocorrelation time for a uniformly sampled time series
% this time is defined as the lag at which the auto-correlation function goes below 1/e for the first time

function act = autoCorrelationTime(S)

if ~isvector(S)
	act = NaN(size(S,2),1);
	for i = 1:size(S,2)
		act(i) = autoCorrelationTime(S(:,i));

	end
	return
end

S = nonnans(S);

temp = autocorr(S,length(S)-1);
act = find(temp<1/exp(1),1,'first');
