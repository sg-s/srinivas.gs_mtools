% struct2vec.m
% struct2vec converts a deeply nested structure
% into a vector, with a corresponding list 
% of names
% it ignores elements that are not numbers 
% it evaluates function handles -- they better
% return doubles 
% you can invert this using vec2struct

function [v, names, is_relational] = struct2vec(s)

	v = [];
	names = {};
	is_relational = [];

	f = fieldnames(s);

	for i = 1:length(f)
		if isstruct(s.(f{i}))
			% go one level deeper
			[this_v, this_name, this_rel] = struct2vec(s.(f{i}));
			for j = 1:length(this_name)
				this_name{j} = [inputname(1)  '_' f{i}   this_name{j} ];
			end
			names = [names; this_name(:)];
			v = [v; this_v(:)];
			is_relational = [is_relational; this_rel];
		else
			if ~ischar(s.(f{i}))

				% if it's a function handle, evaluate it before storing it
				if isa(s.(f{i}),'function_handle')
					v = [v; funeval(s.(f{i}))];

					this_rel = true;
				else
					v = [v; s.(f{i})];
					this_rel = false;
				end

				this_name = [inputname(1) '_' f{i}  ];
				names = [names; this_name];
				is_relational = [is_relational; this_rel];
			end
		end
	end

end


