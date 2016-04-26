% l2.m
% calcualtes the l2 norm between 2 vectors a and b
% usage:
% [d] = l2(a,b);
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [d] = l2(a,b);
a = a(:);
b = b(:);
d = sqrt(sum((a-b).^2));