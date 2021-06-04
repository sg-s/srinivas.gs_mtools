function C = cv(X)

X = X(:);
rm_this = isnan(X) | isinf(X);

C = std(X(~rm_this))/mean(X(~rm_this));