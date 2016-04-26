% from here: http://www.nathankarst.com/blog/modular-multiplicative-inverses-in-matlab
function xInv = modInv(x,n)
% ModInv(x,n) computes the multiplicative inverse of x modulo n if one
% exists; errors if no such inverse exists
if gcd(x,n) ~= 1
    error('x has no inverse modulo n')
end

[d, a, b]   = gcd(x,n);
xInv        = mod(a,n);
end