% width.m
% width is like the built in "length"
% and returns the second largest dimension of the matrix
%
% e.g: width(zeros(1000,3)) returns 3
% it also returns the dimension that it is wide in
% e.g. [w, wdim] = width(A)
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [w, wdim] = width(A)
if ~nargin
	help width
	return
else
	if isvector(A)
		w = 1;
	else
		w=sort(size(A));
		w=w(end-1);

		if nargout > 1
			wdim = find(w == size(A));
		end
	end
end

