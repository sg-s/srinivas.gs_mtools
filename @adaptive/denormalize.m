function [new_x,new_y] = denormalize(self, x,y)

	
if strcmp(self.XScale,'log')
	error('Not coded')
	new_x = exp(x*(log(self.x_range(2)) - log(self.x_range(1))) + log(self.x_range(1)));
else
	new_x = self.Lower(1) + x*(self.Upper(1) - self.Lower(1));
end

if strcmp(self.YScale,'log')
	error('Not coded')
	new_y = exp(y*(log(self.y_range(2)) - log(self.y_range(1))) + log(self.y_range(1)));
else
	new_y = self.Lower(2) + y*(self.Upper(2) - self.Lower(2));
end


