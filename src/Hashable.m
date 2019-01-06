% defines a hashable object, i.e.,
% one that you call hash() on

classdef Hashable


methods


	function H = hash(self, strict_mode)

		if nargin == 1
			strict_mode = false;
		end

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
			end
		end
		h1 = GetMD5(double_values);
		h2 = GetMD5(char_values);
		H = GetMD5([h1 h2]);
	end

end


end % classdef