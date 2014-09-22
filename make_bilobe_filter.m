% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = make_bilobe_filter(tau1,n1,tau2,n2,t)
f1 = t.^n1.*exp(-t/tau1); % functional form in paper
f1 = f1/tau1^(n1+1)/gamma(n1+1); % normalize appropriately


f2 = t.^n2.*exp(-t/tau2); % functional form in paper
f2 = f2/tau2^(n2+1)/gamma(n2+1); % normalize appropriately

f = f1 - f2;
f = f/max(f);