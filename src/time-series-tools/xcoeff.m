% xcoeff.m
% computes the cross-correlation coefficient between two signals
% 
% created by Srinivas Gorur-Shandilya at 1:20 , 10 June 2015. Contact me at http://srinivas.gs/contact/
% 
% this is meant to match the definition given in Westwick & Kearney (Identification of Nonlinear Physiological Systems)
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function x = xcoeff(a,b)

% compute the cross covariance
x = xcov(a,b);

% normalise correctly
aa = xcov(a);
bb = xcov(b);

aa = aa(ceil(length(aa)/2));
bb = bb(ceil(length(bb)/2));

x = x/(sqrt(aa*bb));

