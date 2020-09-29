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
	item 
end % private props

properties

end % props



methods 

	function self = List(item)

		if nargin == 0
			return
		end

		assert(isa(item,'cell'),'Expected argument to be a cell array')
		item = item(:);

		if numel(item) > 1
			for j = numel(item):-1:1
				self(j).item = item{j};
			end
		elseif numel(item) == 0
			self = List.empty;
		else
			self.item = item;
		end
		
	end % constructor


	
	function value = subsref(self,key)
		
		value = builtin('subsref',self,key);
		value = value.item;

		% this effectively force-unwraps a list
		if iscell(value)
			value = value{1};
		end

	end

end % methods





methods (Access = protected)

	function displayScalarObject(self)
		disp(self.item)
	end


	function displayNonScalarObject(self)
		disp({self.item})
	end

end


methods (Static)

	function test()

		disp('Creating an empty list:')
		disp(List({}))

		disp('Creating a list with 1 element:')
		disp(List({'a'}))

		disp('Creating a list with many elements:')
		disp(List({'a','b',1}))

	end

end % static methods






end % classdef

