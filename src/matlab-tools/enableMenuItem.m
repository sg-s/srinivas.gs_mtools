% enables the menu item in a vector of 
% handles specified by handle
% where the item has a property "property"
% that has a value "value"
% usage
% disableMenuItem(handle, property, value)

function enableMenuItem(handles, property, value)

V = {handles.(property)};

if ischar(value)
	handles(strcmp(V,value)).Enable = 'on';
else
	idx = cellfun(@(x) isequal(x,value), V);
	handles(idx).Enable = 'on';
end