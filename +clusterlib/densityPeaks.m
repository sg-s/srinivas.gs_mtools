%% cluster 2D data using the density peaks algorithm
% usage:
% [L] = densityPeaks(X)
% where X is a 2xN matrix specifying co-ordinates of the points you want to cluster
% and L is a 1xN labelled matrix
%
function [L,center_idxs] = densityPeaks(X,varargin)

switch nargin
case 0
	help clusterlib.densityPeaks
	return
end

assert(length(size(X)) == 2,'first input should be a matrix')
if size(X,2) > size(X,1)
	X = X';
end


% options and defaults
options.method = 'gaussian';
options.percent = 2;
options.sigma = 20;
options.trim_halo = false;
options.NClusters = Inf;
options.ShowPlot = false;
options.M = 10;
options.Distance = 'euclidean';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});

if strcmp(options.Distance,'precomputed')
    d = X;
else
    d = pdist2(X,X,options.Distance);
end

[L, center_idxs] = clusterlib.internal.cluster_dp(d, options);

if options.ShowPlot
    temp = figure; hold on
    c = lines(max(L));
    for i = 1:max(L)
        plot(X(L==i,1),X(L==i,2),'+','Color',c(i,:))
    end
    prettyFig
end