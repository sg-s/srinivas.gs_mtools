% fastFilter.m
% wrapper for convnfft that uses FFTs and GPU acceleration to filter more quickly
% 
% created by Srinivas Gorur-Shandilya at 5:04 , 05 February 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function y = fastFilter(K,d,S)

options.GPU = true;
options.Power2Flag = true;

if length(K) > 5e3
	y = veclib.convnfft(S(:),K(:),[],[],options);
	y = y(1:length(S));
	y = y/sum(K);
else
	y = filter(K,d,S);
end