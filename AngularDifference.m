% computes absolute angular distance between two angles in degrees
% created by Srinivas Gorur-Shandilya at 16:55 , 15 February 2014. Contact me at http://srinivas.gs/contact/
function [d] = AngularDifference(a,b)
a = mod(a,360);
b = mod(b,360);
d1=abs(a-b);
d2 = abs(360-d1);
d = min([d1 d2]);
