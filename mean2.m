% calcualtes the mean excluding all NaNs
% created by Srinivas Gorur-Shandilya at 14:17 , 24 January 2014. Contact me at http://srinivas.gs/contact/
function [m] = mean2(x)
m = mean(x(~isnan(x)));
