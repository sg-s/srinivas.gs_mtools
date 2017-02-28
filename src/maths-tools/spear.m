% computes Spearman correlation between two vectors x and y
% uses MATLAB's built in corr function
% this wrapper makes it a little easier to use

function [rho,p] = spear(x,y)
x = x(:);
y = y(:);
rm_this = isnan(x) | isnan(y);
[rho,p] = corr(x(~rm_this),y(~rm_this),'type','Spearman');