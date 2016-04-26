% cv.m 
% coefficient of variation of a matrix of a vector.
% 
% usage:
% c = cv(x)
% where x is a vector or a matrix. if x is a matrix, c is a vector as long as x is wide. 
% created by Srinivas Gorur-Shandilya at 5:44 , 26 November 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
% calcualtes the coefficient of variation of an input vector
% usage c = cv(x);
function c = cv(x)
if ~nargin
	help cv
	return
end

if isvector(x)
	x= x(:);
	c = abs(std(x)/mean(x));
else
	c = zeros(1,width(x));
	if  size(x,1) >size(x,2)	
		x = x';
	end

	for i = 1:width(x)
		c(i) = abs(std(x(i,:))/mean(x(i,:)));
	end
end