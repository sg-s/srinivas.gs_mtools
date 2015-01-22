% rsquare.m
% computes the coefficent of determination between two inputs
% r = rsquare(x,y)
% returns a scalar if x and y are vectors
% 
% if x and y are matrices, rsquare returns a matrix with dimensions equal to the width of x and y
% created by Srinivas Gorur-Shandilya at 3:46 , 22 January 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = rsquare(x,y)
switch nargin 
	case 0
		help rsquare
		return
	case 1 
		y = 0;
end

if isvector(x) && isvector(y)
	x = x(:);
	y = y(:);

	% ignore NaNs
	deletethis = find(isnan(x));
	deletethis = unique([deletethis find(isnan(y))]);
	x(deletethis) = [];
	y(deletethis) = [];

	[~, r]=fit(x,y,'Poly1');
	r = r.rsquare;
elseif ~isvector(x)
	[a, adim] = width(x);

	r = NaN(a);
	for i = 1:a-1
		for j = i+1:a
			if adim == 1
				xx = x(i,:);
				yy = x(j,:);
			else
				xx = x(:,j);
				yy = x(:,j);
			end

			xx = xx(:);
			yy = yy(:);

			% ignore NaNs
			deletethis = find(isnan(xx));
			deletethis = unique([deletethis find(isnan(yy))]);
			xx(deletethis) = [];
			yy(deletethis) = [];

			[~, temp]=fit(xx,yy,'Poly1');
			r(i,j) = temp.rsquare;
		end
	end
end