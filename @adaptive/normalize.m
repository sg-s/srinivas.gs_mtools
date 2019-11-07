% normalizes the co-ordinates to be b/w 0 and 1

function [X,Y] = normalize(self)
	
X = self.SamplePoints(:,1);
Y = self.SamplePoints(:,2);

% convert to normalized coordinates

if strcmp(self.XScale,'log')
	error('Not coded')
	X = log(X) - log(self.x_range(1));
	X = X/( log(self.x_range(2)) - log(self.x_range(1)));
else
	X = X - self.Lower(1);
	X = X/(self.Upper(1) - self.Lower(1));
end

if strcmp(self.YScale,'log')
	error('Not coded')
	Y = log(Y) - log(self.y_range(1));
	Y = Y/( log(self.y_range(2)) - log(self.y_range(1)));
else
	Y = Y - self.Lower(2);
	Y = Y/(self.Upper(2) - self.Lower(2));
end


