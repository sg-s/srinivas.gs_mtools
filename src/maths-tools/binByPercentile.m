% binByPercentile
% finds n bins so that each bin has the same number of points
% usage:
% bin_edges = binByPercentile(X,n_bins)
% where X is a vector of your data
% and n_bins is a scalar
% bin_edges will have length n_bins + 1 
function [bin_edges] = binByPercentile(X,n_bins)

cX = cumsum(hist(X,length(X)));
cX = cX/max(cX);
bin_edges = NaN(n_bins+1,1);

X_sorted = sort(X);

increment = 1/n_bins;

for i = 1:n_bins-1
	this_cutoff = increment*i;
	x = find(cX>this_cutoff,1,'first');
	bin_edges(i+1) = X_sorted(x);
end

bin_edges(1) = X_sorted(1);
bin_edges(end) = X_sorted(end);