% handy utility to set fields in a vector of axes
% 
% example:
% axlib.set(ax, 'XScale','log')
% 
function set(ax, Name, Value)

arguments
	ax (:,:) matlab.graphics.axis.Axes
	Name (1,1) string
	Value 
end


% we need this idiotic try catch block because it is possible
% that Value is a handle that we want to replicate across axes
% if we don't copy a handle object, we just move it from place to 
% place. however, there is no copy function for doubles, 
% the worst thing is that there is no way to tell a graphics handle
% from a double. ishandle is useless because ishandle(1) will always
% be true if there is a figure open
% isgraphics is equally useless

for i = 1:numel(ax)
	try
		set(ax(i),Name,copy(Value))
	catch
		set(ax(i),Name,Value)
	end
end

