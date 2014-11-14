% hill4.m
% 4-parameter Hill function
% usage: r = hill4(x,xdata)
% where x(1) specifies the maximum
% x(2) specifies the location of the inflection point
% x(3) specifies the steepness 
% x(4) specifies some offset (the value the function takes at very low values)
% Usage:
% r = hill(x,xdata)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = hill4(x,xdata)
if ~nargin 
	help hill4
	return
end

A = x(1);
k = x(2);
n  =x(3);
offset = x(4);

r = A*xdata.^n;
r = r./(xdata.^n + k^n);
r= r+ offset;

	
% when xdata is negative, return 0
r(xdata<0) = offset;	