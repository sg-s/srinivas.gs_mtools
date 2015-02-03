% Cost.m
% computes a cost for two vectors
% created by Srinivas Gorur-Shandilya at 13:36 on 02-April-2014. Contact me at http://srinivas.gs/
% usage: c = Cost2(a,b)
function c = Cost2(a,b)
if ~nargin
	help Cost2
	return
end
a = a(:);
b = b(:);

% ignore NaNs, but penalize
rm_this =[];
rm_this = [rm_this find(isnan(a))];
rm_this = [rm_this find(isnan(b))];
a(rm_this) = [];
b(rm_this) = [];

if length(a) > 10
	c = sqrt(sum((a-b).^2)); % distance to solution
else
	c= Inf;
end


