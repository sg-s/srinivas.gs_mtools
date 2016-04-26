% hillFit.m
% hill function meant to be called by fit()
% 
% created by Srinivas Gorur-Shandilya at 11:25 , 04 February 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function r = hillFit(x,A,k,n,x_offset)

x = x - x_offset;

r = A*x.^n;
r = r./(x.^n + k^n);
	
% when x is negative, return 0
r(x<0) = 0;	

if any(~isreal(r))
	r(~isreal(r)) = 0;
end

if any(isnan(r))
	r(isnan(r)) = 0;
end