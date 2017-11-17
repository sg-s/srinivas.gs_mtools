% rsquare.m
% computes the [coefficent of determination](http://en.wikipedia.org/wiki/Coefficient_of_determination) between two inputs
% r = rsquare(x,y)
% returns a scalar if x and y are vectors
% 
% r = rsquare(x)
% if x is a matrix, rsquare returns a matrix r with dimensions equal to the width of x 
% 
% [r,s] = rsquare(x,y)
% returns an additional output s, that contains the slopes of the lines fit to the two things being compared. 
% created by Srinivas Gorur-Shandilya at 3:46 , 22 January 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [r,s] = rsquare(x,y)
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
	deletethis = unique([deletethis; find(isnan(y))]);
	x(deletethis) = [];
	y(deletethis) = [];

	assert(length(x) == length(y),'Both input vectors should be the same length')
	assert(length(x)>2,'Vector inputs too short. Maybe all NaN?')

	[s, r]=fit(x,y,'Poly1');
	r = r.rsquare;
	s = s.p1;
elseif ~isvector(x)
	if size(x,1) > size(x,2)
		x = x';
	end

	% check the cache to see if we have already done this
	hash = dataHash(x);
	r = cache(strcat(hash,'r'));
	if ~isempty(r)
		s = cache(strcat(hash,'s'));
		if ~isempty(s)
			return
		end
	end

	[a, adim] = width(x);

	r = NaN(a);
	s = NaN(a);
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

			if ~isempty(xx)
				[temp2, temp]=fit(xx,yy,'Poly1');
				r(i,j) = temp.rsquare;
				s(i,j) = temp2.p1;
			end
		end
	end

	% cache for later use
	cache(strcat(hash,'s'),s);
	cache(strcat(hash,'r'),r);
end