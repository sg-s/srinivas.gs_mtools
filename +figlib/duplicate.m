% creates a duplicate of the figure that you have right now
%
% created by Srinivas Gorur-Shandilya at 2:51 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function h2 = duplicate(h1)
switch nargin 
case 0
	help figlib.duplicate
	return
end
h2=figure;
objects=allchild(h1);
copyobj(get(h1,'children'),h2);
set(gcf,'color',get(h1,'color'))
set(gcf,'position',get(h1,'position'))

