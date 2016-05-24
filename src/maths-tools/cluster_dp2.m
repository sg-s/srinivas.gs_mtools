%% cluster_dp2.m
% density peaks based clustering with some automatic cluster center detection
% see: http://eric-yuan.me/clustering-fast-search-find-density-peaks/
% modified version of cluster_dp.m
% in this version, we compute density differently. 
% instead of finding the number of points within a given circle (or whatever)
% we find the locations of the M closest points
% and the density of the point varies inversely with the standard deviation of the distances of the M points from that point

function [cluster_lables, center_idxs] = cluster_dp2(D, options)

global R

%% Compute rho(density)
rho = NaN(length(D),1);
for i = 1:length(rho)
    % find the M closest points
    [sd,idx] = sort(D(:,i),'ascend');
    sd(sd>mean(mean(D))) = NaN;
    rho(i) = 1/nanmean(sd(2:options.M+1));
end

rho = rho - min(rho);
rho = rho/max(rho);

figure, hold on
c = parula(100);
for i = 1:length(rho)
    plot(R(i,1),R(i,2),'+','Color',c(1+ceil(99*rho(i)),:))
end

keyboard

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

figure, hold on
plot(rho, delta,'k+')
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

