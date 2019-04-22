classdef (Abstract) VectorObject


properties

end


methods

	function self = VectorObject(N)

		if nargin == 0 
			return
		end


		props = properties(self);


		for i = N:-1:1
			for j = 1:length(props)
				% yes, this 1 is correct, not an i
				%keyboard
				%eval(['E=' class(self(1).(props{j})) '.empty();'])

				self(i).(props{j}) = (self(1).(props{j}));
			end
		end


		

	end


end


end % classdef 