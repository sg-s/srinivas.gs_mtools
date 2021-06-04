% findCorrelationTime.m
% finds the correlation time of a vector. returns an answer in the units of vector indices
% usage:
% [zctime,tau] = findCorrelationTime(x)
% where x is a vector
% zctime is the time of zerocrossing of the sample autocorrelation function
% and tau is the timescale of an exponential fitted to the sample autocorrelation function
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [zctime,tau,c,half_cross_time] = findCorrelationTime(x)
switch nargin
case 0
	help findCorrelationTime
	return
case 1
	if ~isvector(x)
		error('Input argument must be a vector')
	end
	x = x(:);
otherwise
	error('Too many input arguments')
end


c = autocorr(x,length(x)-1);
zctime = find(c<0,1,'first')-1;

half_cross_time = find(c<.5,1,'first')-1;



if nargout > 1
	tau = NaN;
	try
		ff=fit((1:zctime)',c(1:zctime),'exp1');
		tau = abs(1/ff.b);
	catch
		keyboard
	end
	
end
