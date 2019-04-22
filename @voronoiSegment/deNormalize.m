function [new_x,new_y] = deNormalize(self, x,y)

	
if strcmp(self.x_scale,'log')
		new_x = exp(x*(log(self.x_range(2)) - log(self.x_range(1))) + log(self.x_range(1)));
else
	new_x = self.x_range(1) + x*diff(self.x_range);
end

if strcmp(self.y_scale,'log')
	new_y = exp(y*(log(self.y_range(2)) - log(self.y_range(1))) + log(self.y_range(1)));
else
	new_y = self.y_range(1) + y*diff(self.y_range);
end


