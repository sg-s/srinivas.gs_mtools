% converts a categorical array to a cell array
function X = categorical2cell(C)

C = C(:);

X = cell(length(C),1);

for i = 1:length(C)
	X{i} = char(C(i));
end