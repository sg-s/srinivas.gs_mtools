% normalizes the co-ordinates to be b/w 0 and 1
% Normalize is used internally for almost everything,
% as it allows for uniform sampling in the space,
% whether you have a log scale or not

function [X,Y] = normalize(self)
	
X = self.SamplePoints(:,1);
Y = self.SamplePoints(:,2);

% convert to normalized coordinates

if strcmp(self.XScale,'log')

	X = log(X) - log(self.Lower(1));
	X = X/(log(self.Upper(1)) - log(self.Lower(1)));
else
	X = X - self.Lower(1);
	X = X/(self.Upper(1) - self.Lower(1));
end

if strcmp(self.YScale,'log')
	Y = log(Y) - log(self.Lower(2));
	Y = Y/(log(self.Upper(2)) - log(self.Lower(2)));
else
	Y = Y - self.Lower(2);
	Y = Y/(self.Upper(2) - self.Lower(2));
end


