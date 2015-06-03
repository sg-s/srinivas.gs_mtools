% 2-lobed gamma filter
% usage: f = filter_gamma2(t,p)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = filter_gamma2(t,p)
switch nargin
case 0
	help filter_gamma2
	return
case 1
	p = t;
	t = 1:1000;
case 2
	if isempty(t)
		t = 1:1000;
	end
end	

% force tau1 to be smaller than tau2
if p.tau1 > p.tau2
	temp = p.tau2;
	p.tau2 = p.tau1;
	p.tau1 = temp;
end

f1 = t.^p.n.*exp(-t/p.tau1); % functional form in paper
f1 = f1/p.tau1^(p.n+1)/gamma(p.n+1); % normalize appropriately

f2 = t.^p.n.*exp(-t/p.tau2); % functional form in paper
f2 = f2/p.tau2^(p.n+1)/gamma(p.n+1); % normalize appropriately

f = f1 - p.A*f2;
f = f/max(abs(f));

