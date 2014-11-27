% bilobed_alpha_filter.m
% four parameter bilobed filter based on an alpha function
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% usage: K = filter_alpha(tau,A,t)
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function K = filter_alpha(tau,A,t)
switch nargin
case 0
	help filter_alpha
	return
case 1
	% check to see if we are getting a vector
	if isvector(tau) && length(tau) == 2
		A = tau(2); tau = tau(1);
		t = 1:1000;
	else
		error('Not enough input arguments')
	end 
case 2
	t = 1:1000;
end
alpha = 1/tau;
K = ((alpha^2)*exp(-alpha*t).*t);
K = K/max(K);

K = A*K;
