%%
% The List class
% The List class is a simple wrapper around cell
% that allows you to access (:,1) cell arrays
% using ()
%
% WTF? Why not use built in cell? Because you can
% do this:
%
% for thing = List({'One','Two'})
% 	disp(thing)
% end
% 
classdef List < matlab.mixin.CustomDisplay



properties (Access = private)
	elements (:,1) cell 
end % private props

properties

end % props



methods 

	function self = List(elements)
		self.elements = elements(:);
	end % constructor



	function value = subsref(self,key)
		if strcmp(key.type,'()')
			value = self.elements{key.subs{1}};
		else
			error('Access List elements using ()')
		end

	end

end % methods





methods (Access = protected)

	function displayScalarObject(self)
		disp(self.elements)
	end

end


methods (Static)

end % static methods






end % classdef

