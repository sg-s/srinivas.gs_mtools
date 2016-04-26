% mdot.m
% mdot returns the column-wise dot product of a matrix
% B = mdot(A);
% returns a vector as long as A, where each element is the dot product of each value in each column of A
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function B = mdot(A)
switch nargin
case 0
	help mdot
	return
case 1
	B = ones(1,length(A));
	s = size(A);
	if s(1) > s(2)
		A = A';
	end
	for i = 1:width(A)
		B = B.*A(i,:);
	end
otherwise
	error('Too many input arguments')
end