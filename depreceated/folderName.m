% folderName.m
% returns the current folder's name
% 
% created by Srinivas Gorur-Shandilya at 12:44 , 27 November 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [f] = folderName()
temp = cd;
s=strfind(temp,filesep);
f = temp(s(end)+1:end);