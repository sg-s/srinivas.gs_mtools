% struct2vec.m
% struct2vec converts a deeply nested structure
% into a vector, with a corresponding list 
% of names
% it ignores elements that are not numbers 
% you can invert this using vec2struct

function [v, names] = struct2vec(s)

v = [];
names = {};

f = fieldnames(s);

for i = 1:length(f)
	if isstruct(s.(f{i}))
		% go one level deeper
		[this_v, this_name] = struct2vec(s.(f{i}));
		for j = 1:length(this_name)
			this_name{j} = [inputname(1)  '_' f{i}   this_name{j} ];
		end
		names = [names; this_name(:)];
		v = [v; this_v(:)];
	else
		if ~ischar(s.(f{i}))

			v = [v; s.(f{i})];


			this_name = [inputname(1) '_' f{i}  ];
			names = [names; this_name];
		end
	end
end