% calcualtes the coefficient of variation of an input vector
function [c] = cv(x)
x= x(:);
c = abs(std(x)/mean(x));