% phasify.m
% converts a time series into a 
% a time-series of phases by filtering,
% and delay and embedding
% inputs: a time series (vector) X

function [theta, rho, mean_rho, std_rho, circ_dev] = phasify(X,delay)

assert(isvector(X),'Input must be a vector')
X = X(:);
X = X - mean(X);

if nargin < 1
	delay = ceil(autoCorrelationTime(X));
else
	delay = ceil(delay);
end

Y = circshift(X,delay);

if nargout == 0
	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1); hold on
	plot(X,Y,'k')
end


[theta,rho] = cart2pol(X,Y);

% find the times when it wraps around
idx = computeOnsOffs(diff(theta)<-6);

if length(idx) == 0
	idx = computeOnsOffs(diff(theta)<.9*min(diff(theta)));
end

phase_bins = linspace(-pi,pi,100);

std_rho = NaN(length(phase_bins)-1,1);
mean_rho = NaN(length(phase_bins)-1,1);

for i = 1:length(mean_rho)-1
	mean_rho(i) = mean(rho(theta > phase_bins(i) & theta < phase_bins(i+1)));
	std_rho(i) = std(rho(theta > phase_bins(i) & theta < phase_bins(i+1)));
end

circ_dev = nanstd(mean_rho)/nanmean(mean_rho); % deviation from a circle 


if nargout == 0

	% figure('outerposition',[0 0 601 701],'PaperUnits','points','PaperSize',[601 701]); hold on
	% subplot(1,1,1);
	subplot(1,2,2); 
	polarplot(theta,rho)


end