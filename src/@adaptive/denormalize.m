function [new_x,new_y] = denormalize(self, x,y)

	
if strcmp(self.XScale,'log')
	new_x = exp(x*(log(self.Upper(1)) - log(self.Lower(1))) + log(self.Lower(1)));
else
	new_x = self.Lower(1) + x*(self.Upper(1) - self.Lower(1));
end

if strcmp(self.YScale,'log')
	new_y = exp(y*(log(self.Upper(2)) - log(self.Lower(2))) + log(self.Lower(2)));
else
	new_y = self.Lower(2) + y*(self.Upper(2) - self.Lower(2));
end


