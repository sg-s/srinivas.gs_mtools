% hill5.m
% 5-parameter Hill function
% usage: r = hill5(x,xdata)
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
function r = hill5(xdata,p)

if ~nargin 
	help hill5
	return
end


% parameters so that FitModel2Data can read this
p.A;
p.k;
p.y_offset;
p.x_offset;
p.n;

% bounds
lb.n = 1;
lb.A = 0;


xdata = xdata + p.x_offset;

r = p.A*xdata.^p.n;
r = r./(xdata.^p.n + p.k^p.n);
r = r + p.y_offset;

r(xdata<0) = 0;
