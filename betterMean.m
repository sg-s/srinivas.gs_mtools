% mean2.m
% mean2 differs from mean in two different ways: it ignores NaNs, and if provided a matrix, mean2 intelligently operates on the shortest dimension. 
% usage: m = mean2(x);
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function m = betterMean(x)
if ~nargin
	help mean2
	return
else
	if isvector(x)
		m = mean(x(~isnan(x) & (~isinf(x))));
	else
		% rotate correctly
		if size(x,2) > size(x,1)
			x = x';
		end

		% first remove trials that are only NaN
		rm_this = (sum(isnan(x)) == length(x));
		x(:,rm_this) = [];

		% then calcualte the mean ignoring NaNs
		m = mean(x','omitnan');
	end
end

m = m(:);