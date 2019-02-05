% defines a hashable object, i.e.,
% one that you call hash() on

classdef Hashable


methods


	function H = hash(self)



		props = properties(self);
		double_values = [];
		char_values = [];


		for i = 1:length(props)
			if isa(self.(props{i}),'double') | isa(self.(props{i}),'logical')
				this_value = double(self.(props{i}));
				double_values = [double_values; this_value(:)];
			elseif isa(self.(props{i}),'char')
				this_value = (self.(props{i}));
				char_values = [char_values; this_value(:)];
			else
				% check if this object inherits from Hashable
				s = superclasses(self.(props{i}));
				if any(strcmp(s,'Hashable'))
					this_hash = self.(props{i}).hash;
					char_values = [char_values; this_hash(:)];
				end
			end
		end
		h1 = GetMD5(double_values);
		h2 = GetMD5(char_values);
		H = GetMD5([h1 h2]);
	end

end


end % classdef