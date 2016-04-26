% filter_exp2.m
% 2-lobed exponentially decaying filter
% usage: K = filter_exp(tau1,tau2,A,B,t)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function K = filter_exp2(tau1,tau2,A,B,t)
switch nargin
case 0
	help filter_exp2
	return
case {1,2,3}
	help filter_exp2
	error('Not enough input arguments')
case 4
	t = 1:1000;
end

K1 = exp(-t/tau1);
K1 = A*K1;

K2 = exp(-t/tau2);
K2 = B*K2;

% normalise correctly
K1 = K1*mean(diff(t));
K1 = K1/tau1;
K2 = K2*mean(diff(t));
K2 = K2/tau2;

K = K1 - K2;