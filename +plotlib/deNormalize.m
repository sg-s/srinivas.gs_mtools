function new_x = deNormalize(x,XLim, log_x)

if log_x
	new_x = exp(x*(log(XLim(2)) - log(XLim(1))) + log(XLim(1)));
else
	new_x = XLim(1) + x*diff(XLim);
end

