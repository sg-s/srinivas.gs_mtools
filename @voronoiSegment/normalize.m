function [X,Y] = normalize(self)
% convert to normalized coordinates
n = find(~isnan(self.x),1,'last');
X = self.x(1:n);
Y = self.y(1:n);
if strcmp(self.x_scale,'log')
	X = log(X) - log(self.x_range(1));
	X = X/( log(self.x_range(2)) - log(self.x_range(1)));
else
	X = X - self.x_range(1);
	X = X/(diff(self.x_range));
end

if strcmp(self.y_scale,'log')
	Y = log(Y) - log(self.y_range(1));
	Y = Y/( log(self.y_range(2)) - log(self.y_range(1)));
else
	Y = Y - self.y_range(1);
	Y = Y/(diff(self.y_range));
end


