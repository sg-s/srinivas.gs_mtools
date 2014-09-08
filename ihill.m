% ihill.m
% Inverse Hill Function
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [xdata] = ihill(x,ydata)

if ~nargin 
	help ihill
	return
end

A = x(1);
k = x(2);
n  =x(3);


xdata = ydata./(A - ydata);

% handle pathalogical cases:
xdata(xdata<0) = 0;

xdata = xdata.^(1/n);
xdata = xdata*k;