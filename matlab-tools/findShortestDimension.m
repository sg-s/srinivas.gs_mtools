% findShortestDimension.m
% finds the shortest dimension in a multidimensional matrix x
% usage: d = FindShortestDimension(x)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function d = findShortestDimension(x)
if ~nargin 
	help findShortestDimension
	return
else
	s = size(x);
	[~,d] = min(s);
end