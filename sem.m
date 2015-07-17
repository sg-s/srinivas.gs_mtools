% sem.m
% computes standard error of mean of a matrix
%
% created by Srinivas Gorur-Shandilya at 11:55 , 14 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [y] = sem(x)

if size(x,2) > size(x,1)
	x = x';
end

% remove trials with NaNs
rm_this = find(isnan(sum(x)));
x(:,rm_this) = [];

y = std(x')/sqrt(width(x));
y = y(:);
