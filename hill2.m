% 2-parameter Hill function
% usage: r = hill2(x,xdata)
% where 
% x(2) specifies the location of the inflection point
% x(3) specifies the steepness 
% the maximum (scaling) is automatically set to the maximum of the input
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/

% where A is the maximum
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = hill2(x,xdata,A)
switch nargin
case 0
	help hill2
	return
case 1
	help hill2
	error('Not enough inputs')
case 2
	A = max(xdata);
	
end

k = x(1);
n  =x(2);

if min(xdata) < 0
	error('Hill function not defined for negative values')
end

r = A*xdata.^n;
r = r./(xdata.^n + k^n);
	