% 2-lobed gamma filter
% usage:  = filter_gamma2(tau1,n,tau2,A,t)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = filter_gamma2(tau1,n,tau2,A,t)
	switch nargin
case 0
	help filter_gamma2
	return
case 1
	% check to see if we are getting a vector
	if isvector(tau1) && length(tau1) == 4
		n = tau1(2); tau2 = tau1(3); A = tau1(4); tau1 = tau1(1);
		t = 1:1000;
	else
		error('Not enough input arguments')
	end 
case 2
	error('Not enough input arguments')
case 3
	t = 1:1000;
case 4
end	
f1 = t.^n.*exp(-t/tau1); % functional form in paper
f1 = f1/tau1^(n+1)/gamma(n+1); % normalize appropriately

f2 = t.^n.*exp(-t/tau2); % functional form in paper
f2 = f2/tau2^(n+1)/gamma(n+1); % normalize appropriately

f = f1 - A*f2;
f = f/max(f);
if any(isnan(f))
	f = zeros(length(f),1);
	f(1) = 1;
end
