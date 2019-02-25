% filter_gamma.m
% usage:  f = filter_gamma(t,p)
% where p is a structure containing parameters 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = filter_gamma(t,p)

% bounds
lb.n = eps;
lb.tau = eps;
lb.A = eps;

ub.tau = 1e3;
ub.n = 10;

switch nargin
case 0
	help filter_gamma
	return
case 1
	if isstruct(t)
		p = t;
		n = p.n; A = p.A; tau = p.tau;
		t = 1:1000;
	else
		error('No parameters specified')
	end
case 2
	if ~isstruct(p)
		error('Second argument should be a struct')
	end
	if isempty(t)
		t = 1:1000;
	elseif ~isvector(t)
		error('First argument should be a vector')
	end
	n = p.n; A = p.A; tau = p.tau;
end

f = t.^n.*exp(-t/tau); 
f = f/tau^(n+1)/gamma(n+1); 

% and then scale
f = f*A;
