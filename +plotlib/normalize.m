function X = normalize(X,XLim, log_x)


if log_x
	X = log(X) - log(XLim(1));
	X = X/( log(XLim(2)) - log(XLim(1)));
else
	X = X - XLim(1);
	X = X/(diff(XLim));
end


