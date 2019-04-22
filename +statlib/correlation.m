function C = correlation(X,Y,varargin)

X = X(:);
Y = Y(:);

rm_this = isnan(X) | isnan(Y);

C = corr(X(~rm_this),Y(~rm_this),varargin{:});