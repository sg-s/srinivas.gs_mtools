% normFilter
% normalises a filter so that it has sum of squares equal to 1
% 
% created by Srinivas Gorur-Shandilya at 2:31 , 07 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [x] = normFilter(x)
x = x/sqrt(sum(x.^2));