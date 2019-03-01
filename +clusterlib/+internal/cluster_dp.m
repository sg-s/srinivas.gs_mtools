%% cluster 2D data using the density peaks algorithm
% 
%  see: http://eric-yuan.me/clustering-fast-search-find-density-peaks/
% for a nice explanation of this
% 
%% Input and Output
% INPUT :
% D : A nCases*nCases matrix. each D(i, j) represents the Dance
%        between the i-th datapoint and j-th datapoint.
% options : options
%        percent : The parameter to determine dc. 1.0 to 2.0 can often yield good performance.
%        method  : alternative ways to compute density. 'gaussian' or
%                  'cut_off'. 'gaussian' often yields better performance.
% OUTPUT :
% cluster_labels : a nCases vector contains the cluster labls. Lable equals to 0 means it's in the halo region
% center_idxs    : a nCluster vector contains the center indexes.

function [cluster_lables, center_idxs] = cluster_dp(D, options)


%% Estimate dc
percent = options.percent;
N = size(D,1);
position = round(N*(N-1)*percent/100);
tri_u = triu(D,1);
sda = sort(tri_u(tri_u~=0));
dc = sda(position);
clear sda; clear tri_u;

%% Compute rho(density)
switch options.method
    % Gaussian kernel
    case 'gaussian'
        rho = sum(exp(-(D./dc).^2),2)-1;
        % "Cut off" kernel
    case 'cut_off'
        rho = sum((D-dc)<0, 2);
end
[~,ordrho]=sort(rho,'descend');

% compute delta
delta = zeros(size(rho));
nneigh = zeros(size(rho));

delta(ordrho(1)) = -1;
nneigh(ordrho(1)) = 0;
for i = 2:size(D,1)
    range = ordrho(1:i-1);
    [delta(ordrho(i)), tmp_idx] = min(D(ordrho(i),range));
    nneigh(ordrho(i)) = range(tmp_idx); 
end
delta(ordrho(1)) = max(delta(:));

% figure, hold on
% plot(rho, delta,'k+')
% keyboard

% automatically pick outliers in rho and delta
r2 = rho;
d2 = delta;
% normalise axes
r2 = r2 - nanmin(r2);
r2 = r2/nanmax(r2);
d2 = d2 - nanmin(d2);
d2 = d2/nanmax(d2);
temp = d2.*r2;

if isinf(options.n_clusters )
    % automatically pick number of clusters
    center_idxs = find(temp > (mean(temp) + options.sigma*std(temp)));
else
    % find the requested number of clusters
    [~,idx] = sort(temp,'descend');
    center_idxs = idx(1:options.n_clusters);
end


%% Assignment
% raw assignment
cluster_lables = -1*ones(size(D,1),1);
for i = 1:length(center_idxs)
    cluster_lables(center_idxs(i)) = i;
end
for i=1:length(cluster_lables)
    if (cluster_lables(ordrho(i))==-1)
        cluster_lables(ordrho(i)) = cluster_lables(nneigh(ordrho(i)));
    end
end
raw_cluster_lables = cluster_lables;

% find and cut off halo region
if options.trim_halo
    for i = 1:length(center_idxs)
        tmp_idx = find(raw_cluster_lables==i);
        tmp_D = D(tmp_idx,:);
        tmp_D(:,tmp_idx) = max(D(:));
        tmp_rho = rho(tmp_idx);
        tmp_lables = raw_cluster_lables(tmp_idx);
        tmp_border = find(sum(tmp_D<dc,2)>0);
        if ~isempty(tmp_border)
            rho_b = max(tmp_rho(tmp_border));
            halo_idx = rho(tmp_idx) < rho_b;
            tmp_lables(halo_idx) = 0;
            % label equals to 0 means it's in the halo region
            cluster_lables(tmp_idx) = tmp_lables;
        end
    end
end

