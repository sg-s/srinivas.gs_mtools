% defines a hashable object, i.e.,
% one that you call hash() on

classdef (Abstract) Hashable


methods
	function H = hash(self)
		H = Hashable.hashObj(self);
	end
end


methods (Static)


	% this implements the actual logic
	function H = hashObj(object)

		assert(length(object) == 1,'Only works for scalar objects')


		props = properties(object);
		hashes = cell(length(props),1);


		for i = length(props):-1:1
			s = superclasses(object.(props{i}));

			if isa(object.(props{i}),'double') || isa(object.(props{i}),'logical') || isa(object.(props{i}),'char')
				x = object.(props{i});
				x = x(:);
				this_hash = hashlib.md5hash(x);
				hashes{i} = this_hash;
			elseif any(strcmp(s,'Hashable'))
				% check if this object inherits from Hashable
				this_hash = object.(props{i}).hash;
				hashes{i} = this_hash;
			elseif isenum(object.(props{i}))
				% cast into char
				x = char(object.(props{i}));
				x = x(:);
				this_hash = hashlib.md5hash(x);
				hashes{i} = this_hash;
			elseif isa(object.(props{i}),'timetable') || isa(object.(props{i}),'table')
				x = object.(props{i}).Variables;
				x = x(:);
				this_hash = hashlib.md5hash(x);
				hashes{i} = this_hash;
			elseif isa(object.(props{i}),'datetime')
				x = datenum(object.(props{i}));
				x = x(:);
				this_hash = hashlib.md5hash(x);
				hashes{i} = this_hash;
			elseif isa(object.(props{i}),'cell')
				% TODO
				% this won't work for cell arrays with heterogeneous types
				this_hash =  hashlib.md5hash([object.(props{i}){:}]);
				hashes{i} = this_hash;
			elseif isa(object.(props{i}),'Unhashable')
				% do nothing
			elseif isa(object.(props{i}),'categorical')
				temp = double(object.(props{i}));
				this_hash = hashlib.md5hash(temp);
				hashes{i} = this_hash;
			else
				disp('Uncoded block')
				keyboard
			end
		end

		H = hashlib.md5hash([hashes{:}]);


	end


end


end % classdef