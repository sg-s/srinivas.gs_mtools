% hill_fit.m
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
function r = hill_fit(xdata,A,k,n,offset)
if ~nargin 
	help hill_fit
	return
end

xdata  =xdata+offset;

r = A*xdata.^n;
r = r./(xdata.^n + k^n);
	
% when xdata is negative, return 0
r(xdata<0) = 0;	

