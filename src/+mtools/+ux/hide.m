% makes visible a GUI object

% usage: mtools.ux.show(object)

function hide(thing)

assert(nargin == 1,'Wrong number of input arguments')

if length(thing) > 1
	for i = 1:length(thing)
		mtools.ux.hide(thing(i));
	end
	return
end

if isprop(thing,'Visible')
	thing.Visible = 'off';
end
if isprop(thing,'Children')
	C = thing.Children;
	for i = 1:length(C)
		mtools.ux.hide(C(i));
	end
	return
end

