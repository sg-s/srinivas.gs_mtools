% given a curve fit object cf, find x such that cf(x) = y
% using linear interpolation
% usage:
% x = cfinvert(cf,y,x_range,precision)
% where
% cf is a curve fit object
% y is the value you want to invert
% and x_range is a 2-element vector specifying the approximate 
% range you think x is at
% precision is an optional argument (an integer)
% specifying the number of steps to interpolate in the x_range

function x = cfinvert(cf,y,x_range,precision)

if nargin < 4
	precision = 1e6;
end

assert(isa(cf,'cfit'),'First argument should be a curve fit object')

X = linspace(x_range(1),x_range(2),precision);
Y = cf(X);
x = interp1(Y,X,y);