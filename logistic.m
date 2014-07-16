% 3-parameter logistic function
% usage: r = logistic(x,xdata)
% where x(1) specifies the maximum
% x(2) specifies the location of the inflection point
% x(3) specifies the steepness 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = logistic(x,xdata)
if ~nargin 
	help logistic
	return
end
A = x(1);
b = x(2);
k  =x(3);
ee = b - k*xdata;
r = A./(1 + exp(ee));
	