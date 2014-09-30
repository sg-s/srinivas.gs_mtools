% bilobed_alpha_filter.m
% four parameter bilobed filter based on an alpha function
% usage:
% K = filter_alpha2(tau1,tau2,A,b,t)\
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function K = filter_alpha2(tau1,tau2,A,b,t)
switch nargin
case 0
	help filter_alpha2
	return
case 1
	% check to see if we are getting a vector
	if isvector(tau1) && length(tau1) == 4
		tau2 = tau1(2); A = tau1(3); b = tau1(4); tau1 = tau1(1);
		t = 1:1000;
	else
		error('Not enough input arguments')
	end 
case 2
	error('Not enough input arguments')
case 3
	error('Not enough input arguments')
case 4
	t = 1:1000;
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

if any(isnan(K))
	keyboard
	error('Error in computing alpha filter')
end
