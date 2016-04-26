% logistic.m
% 3-parameter logistic function
% usage: r = logistic(xdata,A,k,x0)
% where A specifies the maximum
% x0 specifies the location of the inflection point
% k specifies the steepness 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = logistic(xdata,A,k,x0)
if ~nargin 
	help logistic
	return
end

e = - k.*xdata - x0;
r = A./(1 + exp(e));