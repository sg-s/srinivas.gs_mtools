function [X, Y] = normalize(X,Y,XLim, YLim, log_x, log_y)


if log_x
	X = log(X) - log(XLim(1));
	X = X/( log(XLim(2)) - log(XLim(1)));
else
	X = X - XLim(1);
	X = X/(diff(XLim));
end

if log_y
	Y = log(Y) - log(YLim(1));
	Y = Y/( log(YLim(2)) - log(YLim(1)));
else
	Y = Y - YLim(1);
	Y = Y/(diff(YLim));
end


