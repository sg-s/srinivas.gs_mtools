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


if ishandle(Value)
	for i = 1:numel(ax)
		set(ax(i),Name,copy(Value))
	end

else
	for i = 1:numel(ax)
		set(ax(i),Name,Value)
	end
end