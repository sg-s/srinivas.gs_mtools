% cfinvert.m
% given a curve fit object cf, find x such that cf(x) = y

function [x] = cfinvert(cf,y,x_range)

assert(isa(cf,'cfit'),'First argument should be a curve fit object')

X = linspace(x_range(1),x_range(2),1e6);
Y = cf(X);
x = interp1(Y,X,y);