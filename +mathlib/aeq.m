% approximate equality function
% returns 1 if two numbers are within
% machine precision
% should work the same as 
% _approx (deprecated MATLAB function)
%
function L = aeq(x,y)

L = abs(x - y) < eps('single');