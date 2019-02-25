% findExcursions.m
% finds excursions in a plane
% usage:
% [ons,offs] = findExcursions(x,y,xthresh,ythresh)
% where xthresh and ythresh are scalars between 0 and 1
% 		invert is true or false
% 		and x and y are vectors
% 
% created by Srinivas Gorur-Shandilya at 4:11 , 02 March 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [ons,offs] = findExcursions(x,y,xthresh,ythresh,invert)

% defensive programming 
x = x(:); y = y(:);
assert(length(x) == length(y),'First two arguments should be vectors of the same length')

if nargin < 3
	xthresh = .1;
end
if nargin < 4
	ythresh = .1;
end
if nargin < 5
	invert = false;
end

assert(xthresh > 0,'X-threshold should be positive')
assert(ythresh > 0,'Y-threshold should be positive')
assert(xthresh < 1,'X-threshold should be less than 1')
assert(ythresh < 1,'Y-threshold should be less than 1')

% normalise x and y
if invert
	x = -x;
	y = -y;
end
x = x - min(x);
y = y - min(y);
x = x/max(x);
y = y/max(y);

[ons,offs]=computeOnsOffs(y > ythresh & x > xthresh);

