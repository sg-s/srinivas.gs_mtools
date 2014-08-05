% 2-parameter inverse Hill function
% usage: r = ihill2(x,xdata)
% where 
% x(1) specifies the location of the inflection point
% x(2) specifies the steepness 
% the maximum (scaling) is automatically set to the maximum of the input
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = ihill2(x,xdata)
if ~nargin 
	help hill
	return
end
A = max(xdata);
k = x(1);
n = x(2);

if min(xdata) < 0
	error('The Inverse Hill function not defined for negative values')
end


r = k*(xdata./(A-xdata)).^(1/n);
