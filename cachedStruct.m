
% behaves like a struct, except 
% that all changes made to the struct are written to disk

classdef cachedStruct < dynamicprops



properties (Access = private)
	cacheloc 
end % private props

properties

end % props



methods 

	function self = cachedStruct(cacheloc)
		if isdir(cacheloc)
			error('cacheloc should resolve to a file')
		end
		self.cacheloc = cacheloc;
		if exist(cacheloc,'file') == 2
			load(cacheloc,'self','-mat')
		end

	end % constructor


	function self = subsasgn(self, S, value)

		if ~strcmp(S.type,'.')
			error('Only dot notation is supported')
		end

		if ~isfield(self,S.subs)
			self.addprop(S.subs);
		end

		self.(S.subs) = value;

		% save to disk
		save(self.cacheloc,'self');

	end


	function value = subsref(self,S)
		if ~strcmp(S.type,'.')
			error('Only dot notation is supported')
		end

		if ~isfield(self,S.subs)
			value = false;
			return
		end

		value = self.(S.subs);
	end

end % methods



methods (Static)

end % static methods






end % classdef

