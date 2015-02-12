% splinehist.m
% uses smoothing splines to make nice-looking histograms 
% created by Srinivas Gorur-Shandilya at 10:27 , 10 December 2014. Contact me at http://srinivas.gs/contact/
% usage:
% [cx,cy,hx,hy]  = splinehist(d)
% where d is the data (should be a vector)
% use plot(cx,cy) to see the CDF
% and plot(hx,hy) to see the PDF
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [cx,cy,hx,hy]  = splinehist(d)

l_max = 1e3;

cx=sort(d(:));

if length(cx) > l_max
	tt = 1:floor(length(cx)/l_max):length(cx);
	cx_old =cx;
	cx = interp1(1:length(cx),cx,tt,'spline');
	cx = cx(:);
end

cy = cumsum(ones(1,length(cx)));
cy= cy/max(cy);

[cf,gof,output] =fit(cx(:),cy(:),'smoothingspline','SmoothingParam',1-1e-4); % this works well to get smooth the cdf

cy = cf(cx); % cy stores the cumulative prob. density

hy = diff(cy)./(diff(cx)); % the pdf is the derivative of the cdf
hy = hy/length(hy);

% remove NaNs
rm_this = isnan(hy);
hy(rm_this) = [];
hx = cx;
hx(rm_this) = [];

% trim correctly 
hx2 = hx;
hx = (hx(2:end) + hx(1:end-1))/2;

% normalise correctly
hy = hy/sum(hy);

