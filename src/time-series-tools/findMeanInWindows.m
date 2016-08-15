% findMeanInWindows.m
% finds the mean in windows
% 
% created by Srinivas Gorur-Shandilya at 11:56 , 23 February 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.


function  m = findMeanInWindows(ons,offs,X)

assert(isvector(ons),'First argument should be a vector defining window starts')
assert(isvector(offs),'2nd argument should be a vector defining window ends')
assert(length(ons)==length(offs),'Ons and Offs should be the same length')
assert(isvector(X),'3rd argument should be a vector')
assert(min(ons)>1,'First argument should be a vector defining window starts. Negative value encountered. Specify window starts as matrix indices')
assert(max(offs)<length(X),'Window offs should be within the length of the vector')

m = NaN*ons;

for i = 1:length(ons)
	m(i) = nanmean(X(ons(i):offs(i)));
end
