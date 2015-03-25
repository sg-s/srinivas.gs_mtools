% npr2.m
% non-parametric r2 test
% usage:
% r = npr2(a,b);
%
% where a and b are vectors of equal length
% and r is a scalar 
% r tends to 1 as a and b co-vary
% 
% created by Srinivas Gorur-Shandilya at 2:23 , 25 March 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = npr2(a,b)
if ~nargin
	help npr2
	return
else
	if ~isvector(a) || ~isvector(b)
		error('Input arguments must be vectors')
	else
		if length(a) == length(b)
			a = a(:);
			b = b(:);
		else
			error('Input arguments must have equal length.')
		end
	end

end

% sort by a
[~,idx] = sort(a);
r1 = rsquare(b,b(idx));

% sort by b
[~,idx] = sort(b);
r2 = rsquare(a,a(idx));

r = r1*r2;

