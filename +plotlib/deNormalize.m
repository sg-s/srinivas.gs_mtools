function[new_x, new_y] = deNormalize(x,y,XLim,YLim, log_x, log_y)


if log_x
	new_x = exp(x*(log(XLim(2)) - log(XLim(1))) + log(XLim(1)));
else
	new_x = XLim(1) + x*diff(XLim);
end

if log_y
	new_y = exp(y*(log(YLim(2)) - log(YLim(1))) + log(YLim(1)));
else
	new_y = YLim(1) + y*diff(YLim);
end


