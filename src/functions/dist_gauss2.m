% dist_gauss2.m
% distribution from a mixture of 2 gaussians
% 
% created by Srinivas Gorur-Shandilya at 11:30 , 26 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = dist_gauss2(t,p)
switch nargin
case 0
	help dist_gauss2
	return
case 1
	p = t;
	t = 0:1e-3:5;
case 2
	if isempty(t)
		t = 0:1e-3:5;
	end
end	


% set bounds
lb.mu1 = 0;
lb.mu2 = 0;
lb.sigma1 = 0;
lb.sigma2 = 0;
lb.xmin = 0;
lb.xmax = 0;
ub.xmin = 1;
ub.xmax = 1;
ub.mu1 = 5;
ub.mu2 = 5;
ub.sigma2 = 10;
ub.sigma1 = 10;

f1 = normpdf(t,p.mu1,p.sigma1);
f2 = normpdf(t,p.mu2,p.sigma2);
f1(isnan(f1)) = 0;
f2(isnan(f2)) = 0;
f = f1+f2;


% clip to some region
a = max([ 1 floor(p.xmin*length(f))]);
z = min([length(f) floor(p.xmax*length(f))]);
if z == 0 
	z = 1;
end
f(1:a) = 0;
f(z:end) = 0;

f = f/max(f);
