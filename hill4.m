% hill4.m
% 4-parameter Hill function, with a X and a Y offset. the x-offset is automatically determined from the data, so be careful in using this in multiple datasets
% 
% usage:
% r = hill4(xdata,A,k,n,y_offset)
% or 
% r = hill4(xdata,p)
% where p is a parameter structure that contains all the parameters
% 
% hill5 can be fit to data using MATLAB's built in fit function, or using fitModel2Data
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = hill4(xdata,A,k,n,y_offset)

if ~nargin 
	help hill4
	return
elseif nargin == 2
	assert(isstruct(A),'Second argument should be a structure')
	p = A; clear A
else
	p.A = A;
	p.k = k;
	p.n = n;
	p.y_offset = y_offset; 
end


% parameters so that FitModel2Data can read this
p.A;
p.k;
p.y_offset;
p.n;

% bounds
lb.n = 1;
lb.A = 0;


if min(xdata) < 0
	xdata = xdata - min(xdata);
end

r = p.A*xdata.^p.n;
r = r./(xdata.^p.n + p.k^p.n);
r = r + p.y_offset;

