% parseHTML.m
% extracts a section from a text string containing HTML so that only text from a specified tag to the end of the tag is extracted. 
% 
% created by Srinivas Gorur-Shandilya at 14:11 , 19 February 2014. Contact me at http://srinivas.gs/contact/
% 
function [t] = parseHTML(h,tag)

if ~nargin
	help parseHTML
	return
end

t=[];
% check if we can find the tag
if length(strfind(h,tag)) == 1
	% all OK
elseif length(strfind(h,tag)) < 1
	error('Cant find your tag.')
else
	keyboard
	error('Too many hits on your tag. Be more specific.')

end

divstart = strfind(h,tag); 

% find all the </div> after this
divends = strfind(h,'</div>');
divends(divends<divstart) = [];

% find all the new div starts after this.
newdiv = strfind(h,'<div');
newdiv(newdiv<divstart) = [];

for i = 1:length(divends)
	a = newdiv;
	a(a>divends(i)) = [];
	b = divends;
	b(b>=divends(i))=[];
	if length(a)== length(b)
		t=h(divstart:divends(i));
		break
	end
end