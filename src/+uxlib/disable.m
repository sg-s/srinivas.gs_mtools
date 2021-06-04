% disables a UX element

% usage: uxlib.disable(object)

function disable(thing)

assert(nargin == 1,'Wrong number of input arguments')

if length(thing) > 1
	for i = 1:length(thing)
		uxlib.disable(thing(i));
	end
	return
end

if isprop(thing,'Enable')
	thing.Enable = 'off';
end
if isprop(thing,'Children')
	C = thing.Children;
	for i = 1:length(C)
		uxlib.disable(C(i));
	end
	return
end

