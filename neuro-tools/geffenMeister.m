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
if ~isvector(pred)
	pred = mean2(pred);
end

if size(resp,2) > size(resp,1)
	resp = resp';
end
ntrials = width(resp);

% compute quantities of interest
trial_averaged_resp = mean2(resp);
mean_resp = mean(trial_averaged_resp);

P_S = mean((trial_averaged_resp - mean_resp).^2);


temp = resp-repmat(trial_averaged_resp,1,width(resp));
temp = temp.^2;
P_N  = mean(mean(temp'));

temp= (pred-trial_averaged_resp).^2;
temp(isnan(temp)) = [];
P_R = mean(temp);

qx = sqrt(P_S/P_N);
qy = sqrt(P_S/P_R);