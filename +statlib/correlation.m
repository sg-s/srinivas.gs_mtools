function C = correlation(X,Y)

rm_this = isnan(X) | isnan(Y);
X(rm_this) = [];
Y(rm_this) = [];

C = corr(X,Y);