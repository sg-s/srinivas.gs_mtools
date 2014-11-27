% GetLinks
% gets links from a snippet of HTML text (h)
% usage: [a,ra] = GetLinks(h) 
% a returns links, and 
% ra returns relative links
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [a,ra] = GetLinks(h) 
if ~nargin
	help GetLinks
	return
end

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