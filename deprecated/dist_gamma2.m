% dist_gamma2.m
% distribution based on two gamma functions
% 
% created by Srinivas Gorur-Shandilya at 11:30 , 26 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = dist_gamma2(t,p)
switch nargin
case 0
	help dist_gamma2
	return
case 1
	p = t;
	t = 0:.01:5;
case 2
	if isempty(t)
		t = 0:.01:5;
	end
end	


% set bounds
lb.A = 0;
lb.n1 = 0;
lb.n2 = 0;
ub.n1 = 10;
ub.n2 = 10;
lb.xmin = 0;
lb.xmax = 0;
ub.xmin = 1;
ub.xmax = 1;

f1 = t.^p.n1.*exp(-t/p.x1); % functional form in paper
f1 = f1/p.x1^(p.n1+1)/gamma(p.n1+1); % normalize appropriately

f2 = t.^p.n2.*exp(-t/p.x2); % functional form in paper
f2 = f2/p.x2^(p.n2+1)/gamma(p.n2+1); % normalize appropriately

f = f1 + p.A*f2;


% clip to some region
a = max([ 1 floor(p.xmin*length(f))]);
z = min([length(f) floor(p.xmax*length(f))]);
if z == 0
	z = 1;
end
f(1:a) = 0;
f(z:end) = 0;



f = f/max(f);

f = abs(f);