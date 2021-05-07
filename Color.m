
% A type that defines a color
% converts anything you give it into a color

classdef Color



properties (Access = private)

end % private props

properties
	RGB (3,1) = rand(3,1)
end % props



methods 

	function self = Color(C)
		if isvector(C) & length(C) == 3
			
		end

	end % constructor


end % methods



methods (Static)

	function gray
		Color([.5 .5 .5])
	end

end % static methods






end % classdef

