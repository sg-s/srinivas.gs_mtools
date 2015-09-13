% isint.m
% returns 1 if input is an integer, 0 if otherwise
% 
% created by Srinivas Gorur-Shandilya at 11:41 , 13 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function r = isint(X)
r = ~any(X - floor(X));