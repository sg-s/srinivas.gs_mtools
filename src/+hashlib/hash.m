% a wrapper for hashlib.md5hash, which will hash
% anything you throw at it
% this is supposed to work for anything, so it 
% is a bit convoluted, and possibly slow. 
% if you can, use hashlib.md5hash 


function H = hash(thing)

H = 'unhashed';


if isstruct(thing)
	H = hashlib.md5hash(getByteStreamFromArray(thing));
	return
end

if iscell(thing)
	H = {};
	for i = length(thing):-1:1
		H{i} = hashlib.hash(thing{i});
	end
	H = hashlib.hash([H{:}]);

	return
end


if isa(thing,'double') || isa(thing,'char') || isa(thing,'logical')
	H = hashlib.md5hash(thing);
	return
end


if isa(thing,'categorical')
	H = hashlib.md5hash(double(thing));
	return
end

% generic type based fallback
T = class(thing);
T = strrep(T,'.','_');
f = str2func(strcat("hashlib.",T));
try
	H = f(thing);
catch

end