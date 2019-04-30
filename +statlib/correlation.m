function [C,p]= correlation(X,Y,varargin)

X = X(:);
Y = Y(:);

rm_this = isnan(X) | isnan(Y);

[C,p] = corr(X(~rm_this),Y(~rm_this),varargin{:});