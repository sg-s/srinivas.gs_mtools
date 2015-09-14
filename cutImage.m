% cutImage.m
% cuts a small square of an image out a bigger image.
% 
% if the requested portion is too large, cut image pads the image
% usage: [SmallImage] = cutImage(BigImage,centre,cutsize)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function SmallImage = cutImage(BigImage,centre,cutsize)
if ~nargin
	help cutImage
	return
end
cx = round(centre(2));
cy = round(centre(1));
% make sure we are cutting it nicely
[h,l] = size(BigImage);
cutOK =  [(cy-cutsize) (h-cy-74) (cx-cutsize) (l-cx-74)]>0;
ff2 = BigImage; 
if any(~cutOK)
    % just pad everything with zeros, then cut out the image, 
      
    ff2 = vertcat(zeros(cutsize,l),ff2);
    ff2 = vertcat(ff2,zeros(cutsize,l));
    ff2 = [zeros(h+2*cutsize,cutsize) ff2 zeros(h+2*cutsize,cutsize)];
    SmallImage = ff2(cy:cy+2*cutsize,cx:cx+2*cutsize);
else
    SmallImage = BigImage(cy-cutsize:cy+cutsize,cx-cutsize:cx+cutsize);
end
