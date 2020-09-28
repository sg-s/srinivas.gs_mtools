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
			self = List.empty(numel(item));
			for i = 1:length(item)
				self(i).item = item{i};
			end
		else
			self.item = item;
		end

		
		
	end % constructor


	% this effectively force-unwraps a list
	function value = subsref(self,key)
		if numel(self) == 1 && isempty(self.item)
			value = self;
			return
		end

		value = builtin('subsref',self,key);
		value = value.item;
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

	function list = empty(N)
		list = repmat(List({}),N,1);
	end

end % static methods






end % classdef

