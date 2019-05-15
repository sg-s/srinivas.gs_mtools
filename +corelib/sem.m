function S = sem(X)

X = X(:);
X = X(~isnan(X));

S = std(X)/sqrt(length(X));