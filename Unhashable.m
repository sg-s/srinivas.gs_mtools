
% defines a unhashable class,
% which will be ignored by hashing algos

classdef (Abstract) Unhashable



properties (Access = private)

end % private props

properties

end % props



methods 

	function H = hash(self)
		H = '';
	end


end % methods


end % classdef

