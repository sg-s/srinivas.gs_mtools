% enables and shows a thing
% enable is an implicit show

% usage: mtools.ux.show(object)

function enable(thing)

assert(nargin == 1,'Wrong number of input arguments')

if length(thing) > 1
	for i = 1:length(thing)
		mtools.ux.enable(thing(i));
	end
	return
end

if isprop(thing,'Enable')
	thing.Enable = 'on';
end
if isprop(thing,'Visible')
	thing.Visible = 'on';
end

if isprop(thing,'Children')
	C = thing.Children;
	for i = 1:length(C)
		mtools.ux.enable(C(i));
	end
	return
end

