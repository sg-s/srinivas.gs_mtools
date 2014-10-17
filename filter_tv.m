% filter_tv.m
% function that uses a time-varying filter to filter some input x
% usage:
% y = filter_tv(x,y,K);
% where x is a vector and K is the function handle to a time varying filter
% this function should conform to:
% K = function(lag,time);
% i.e., should return a vector K that is as long as lag (a scalar), at the time time (usually a vector index)
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = filter_tv(x,y,K)
switch nargin
case 0
	help filter_tv
	return
case 1
	error('Not enough input arguments')
case 2
	if ~isvector(x)
		error('First argument should be a vector')
	end
	temp = whos('K');
	temp = temp.class;
	if ~strcmp(temp,'function_handle')
		error('2nd argument should be a function handle')
	end
end

A = 1;
f = x;

for i = 1:length(x)
	% calculate the K here
	t = 1:y(i);
	tau = y(i)/10;
	K_this = K(tau,A,t);
	if floor(y(i))+i < length(x)
		x(i:floor(y(i))+i) = filter(K_this,1,x(i:floor(y(i))+i));
	else
	end
	
end