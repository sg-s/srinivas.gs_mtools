% a better remainder/modulo function
% returns remainder if non zero. 
% is remainder is zero, then it returns the divisor.
function [x] = modd(a,b)
x = mod(a,b);
if x == 0
    x = b;
end
if length(x)>1
    x(x==0)=b;
end