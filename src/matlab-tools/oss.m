% oss.m
% returns '/' on *nix, '\' on Windows
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
% returns the correct slash for the operating system.
function [oslash] = oss()
if ispc == 1
    oslash = '\';
elseif isunix == 1
     oslash = '/';
 elseif ismac == 1
     oslash = '/';
end