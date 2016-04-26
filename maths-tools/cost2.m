% cost2.m
% computes a cost for two vectors
% created by Srinivas Gorur-Shandilya at 13:36 on 02-April-2014. Contact me at http://srinivas.gs/
% usage: c = Cost2(a,b)
function c = cost2(a,b)
if ~nargin
	help cost2
	return
end
a = a(:);
b = b(:);

full_length = length(a);

% ignore NaNs, but penalize
rm_this = isnan(a) | isnan(b);
a(rm_this) = [];
b(rm_this) = [];

c = sqrt(sum((a-b).^2)); % distance to solution
if any(rm_this)
	c = c*full_length/(full_length-sum(rm_this));
end

% % penalise extra if the guess has more NaNs than the response
% p = sum(isnan(b))/sum(isnan(a));
% c = c*p;

if isnan(c)
	c = Inf;
end