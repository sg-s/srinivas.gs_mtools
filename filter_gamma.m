% gamma_function.m
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = filter_gamma(tau,n,A,t)
switch nargin
case 0
	help filter_gamma
	return
case 1
	% check to see if we are getting a vector
	if isvector(tau) && length(tau) == 3
		n = tau(2); A = tau(3); tau = tau(1);
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
f = t.^n.*exp(-t/tau); % functional form in paper
f = f/tau^(n+1)/gamma(n+1); % normalize appropriately

% and then scale
f = f*A;
