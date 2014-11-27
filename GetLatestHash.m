% GetLatestHash.m
% gets the SHA-1 hash of the latest git commit at online repository. 
% usage: h = GetLatestHash(url)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function h = GetLatestHash(url)
try
	h = urlread(url);
catch
	h = '000000';
	return
end
a=strfind(h,'/commit/');
h = h(a(1)+8:a(1)+47);