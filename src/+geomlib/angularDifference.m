% angularDifference.m
% computes absolute angular distance between two angles in degrees
% 
% usage: d = angularDifference(a,b)
% where a and b are angles in degrees.
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function d = angularDifference(a,b)
if ~nargin 
	help angularDifference
	return
end

if length(a) > 1 
	d = NaN*a;

	if length(b) == length(a)

		for i = 1:length(a)
			d(i) = angularDifference(a(i),b(i));
		end
		return

	else
		for i = 1:length(a)
			d(i) = angularDifference(a(i),b(1));
		end
		return
	end

end

a = mod(a,360);
b = mod(b,360);
d1=abs(a-b);
d2 = abs(360-d1);
d = min([d1 d2]);
