% struct2vec.m
% struct2vec converts a deeply nested structure
% into a vector, with a corresponding list 
% of names
% it ignores elements that are not numbers 

function [v, names] = struct2vec(s)

v = [];
names = {};

f = fieldnames(s);

for i = 1:length(f)
	if isstruct(s.(f{i}))
		% go one level deeper
		[this_v, this_name] = struct2vec(s.(f{i}));
		for j = 1:length(this_name)
			this_name{j} = [this_name{j} f{i} '_' inputname(1)];
		end
		names = [names; this_name(:)];
		v = [v; this_v(:)];
	else
		if ~ischar(s.(f{i}))

			v = [v; s.(f{i})];

			this_name = [f{i} '_' inputname(1)];
			names = [names; this_name];
		end
	end
end