% cfinvert.m
% given a curve fit object cf, find x such that cf(x) = y
% using linear interpolation
% usage:
% x = cfinvert(cf,y,x_range)
% where
% cf is a curve fit object
% y is the value you want to invert
% and x_range is a 2-element vector specifying the approximate 
% range you think x is at

function x = cfinvert(cf,y,x_range)

assert(isa(cf,'cfit'),'First argument should be a curve fit object')

X = linspace(x_range(1),x_range(2),1e6);
Y = cf(X);
x = interp1(Y,X,y);