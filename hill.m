% hill.m
% 3-parameter Hill function
% usage: r = hill(x,xdata)
% where x(1) specifies the maximum
% x(2) specifies the location of the inflection point
% x(3) specifies the steepness 
% Usage:
% r = hill(x,xdata)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = hill(x,xdata)
if ~nargin 
	help hill
	return
end

if isstruct(x)
	temp=x;
	x= [];
	x(1) = temp.A;
	x(2) = temp.k;
	x(3) = temp.n;
	clear temp
end

if isstruct(xdata) % inputs in wrong order
	temp=xdata;
	xdata = x;
	x = [];
	x(1) = temp.A;
	x(2) = temp.k;
	x(3) = temp.n;
	clear temp
end

A = x(1);
k = x(2);
n  =x(3);

r = A*xdata.^n;
r = r./(xdata.^n + k^n);
	
% when xdata is negative, return 0
r(xdata<0) = 0;	

