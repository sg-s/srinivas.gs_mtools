% defines a hashable object, i.e.,
% one that you call hash() on

classdef (Abstract) HashableHandle < handle


methods
	function H = hash(self)
		H = Hashable.hashObj(self);
	end
end


end % classdef