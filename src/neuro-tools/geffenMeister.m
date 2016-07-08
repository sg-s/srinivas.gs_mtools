% GeffenMeister.m
% performs a trial-wise analysis of model fits as done in Geffen and Meister 2009
% usage
% [qx qy] = GeffenMeister(resp,pred)
% where resp and pred are matrices of equal sizes.
% resp is a matrix of the response data, where the short dimension indexes over trials. 
% this only works if resp is a matrix. so don't try this with vectors.  
% pred can be a matrix or a vector. if pred is a matrix, it will be averaged into a vector
%
% created by Srinivas Gorur-Shandilya at 10:58 , 13 March 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [qx, qy] = geffenMeister(resp,pred)
if ~nargin 
	help GeffenMeister
	return
end


if isvector(resp)
	error('first argument has to be a matrix')
end

% make sure matrices are oriented properly
if size(resp,2) > size(resp,1)
	resp = resp';
end
if size(pred,2) > size(pred,1)
	pred = pred';
end


if ~isvector(pred)
	pred = mean(pred,2);
end

% compute quantities of interest
trial_averaged_resp = nanmean(resp,2);
mean_resp = nanmean(trial_averaged_resp);

P_S = nanmean((trial_averaged_resp - mean_resp).^2);

P_N  = mean(mean((resp - repmat(trial_averaged_resp,1,width(resp))).^2,2));

P_R = nanmean((pred - trial_averaged_resp).^2);

qx = sqrt(P_S/P_N);
qy = sqrt(P_S/P_R);