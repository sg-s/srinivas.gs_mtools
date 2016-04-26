%% shuffle.m
% shuffles a vector 
% usage:
% 
% X = shuffle(X);

function [X] = shuffle(X)
assert(isvector(X),'Argument must be a vector');
X = X(randperm(length(X)));