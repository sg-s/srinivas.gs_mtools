% finds the distance (l-2 norm) b/w two points
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function d = distance(p1,p2)
if ~nargin
	help distance
	return
end

d = (p1(1) - p2(1))^2 + (p1(2)-p2(2))^2;
d = sqrt(d);