% makes visible a GUI object

% usage: mtools.ux.show(object)

function show(thing)

assert(nargin == 1,'Wrong number of input arguments')

if length(thing) > 1
	for i = 1:length(thing)
		mtools.ux.show(thing(i));
	end
	return
end

if isprop(thing,'Visible')
	thing.Visible = 'on';
end
if isprop(thing,'Children')
	C = thing.Children;
	for i = 1:length(C)
		mtools.ux.show(C(i));
	end
	return
end

