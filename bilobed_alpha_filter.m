% bilobed_alpha_filter.m
% four parameter bilobed filter based on an alpha function
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function K = bilobed_alpha_filter(t,tau1,tau2,A,b)
if ~nargin
	help bilobed_alpha_filter
	return
end
alpha = 1/tau1;
K = ((alpha^2)*exp(-alpha*t).*t);
K = K/max(K);

alpha = 1/tau2;
K2 = ((alpha^2)*exp(-alpha*t).*t);
K2 = K2/max(K2);
K2 = K2*b;


K = K - K2;
K = K/max(K);


K = A*K;
