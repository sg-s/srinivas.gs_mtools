% GetLinks
% created by Srinivas Gorur-Shandilya at 16:12 , 19 February 2014. Contact me at http://srinivas.gs/contact/
% gets links from a snippet of HTML
function [a,ra] = GetLinks(h) 

linkstarts = strfind(h,'href="http://');
linkends = 0*linkstarts;

for i = 1:length(linkstarts)
	% find the first link end
	temp = strfind(h,'</a>');
	if ~isempty(temp)
		if temp(1) < linkstarts(i)
			temp(temp<linkstarts(i)) = [];
		end
		linkends(i) = temp(1);
	end

end

a = {};
for i = 1:length(linkstarts)
	temp = h(linkstarts(i):linkends(i));
	c = strfind(temp,'"');
	a{i} = temp(c(1)+1:c(2)-1);
end

% also get relative links
linkstarts = strfind(h,'href=');
linkends = 0*linkstarts;

for i = 1:length(linkstarts)
	% find the first link end
	temp = strfind(h,'</a>');
	if ~isempty(temp)
		if temp(1) < linkstarts(i)
			temp(temp<linkstarts(i)) = [];
		end
		linkends(i) = temp(1);
	end

end

ra = {};
for i = 1:length(linkstarts)
	temp = h(linkstarts(i):linkends(i));
	c = strfind(temp,'"');
	ra{i} = temp(c(1)+1:c(2)-1);
end