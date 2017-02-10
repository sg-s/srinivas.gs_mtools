% filter_gamma.m
% usage:  f = filter_gamma(t,p)
% where p is a structure containing parameters 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function f = pLFPfilter(t,p)

% parmeters
p.n;
p.A;
p.tauA;
p.tauB;



A = t.^p.n.*exp(-t/p.tauA); 
A = A/p.tauA^(p.n+1)/gamma(p.n+1); 
A = A*p.A;

B = t.^p.n.*exp(-t/p.tauB); 
B = B/p.tauB^(p.n+1)/gamma(p.n+1); 
B = B*(1-p.A);

f = A + B;

f = f/norm(f);