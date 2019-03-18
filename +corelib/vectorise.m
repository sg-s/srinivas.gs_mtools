% convert any object into a vector
% if x is an array, it is made into a simple vector
% if x is a structure, it is made into a vector using all double-like props
% if x is some sort of object, it is made into a vector using all double-like props


function [x, names] = vectorise(obj)

names = {};

if isa(obj,'double')
	x = obj(:);

	return
elseif isstruct(obj)
	[x, names] = structlib.vectorise(obj);
else
	% some sort of object
	assert(isscalar(obj),'object must be a scalar object')
	names = properties(obj);
	x = NaN(length(names),1);
	for i = 1:length(names)
		if isscalar(obj.(names{i})) && isnumeric(obj.(names{i}))
			x(i) = obj.(names{i});
		end
	end

end