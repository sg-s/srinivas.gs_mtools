% returns a approximately unique values from a vector

function Y = approxUnique(X)

U = unique(X);
rm_this = find(diff(U) <= eps('single'));
U(rm_this) = [];
Y = U;