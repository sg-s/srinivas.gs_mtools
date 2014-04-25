% getComputerName.m
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [name shortname] = getComputerName()
[status, name] = system('hostname');   

if ~status 
   if ispc
      name = lower(getenv('COMPUTERNAME'));
   else      
      name = lower(getenv('HOSTNAME'));      
   end
end

d = strfind(name,'.');
if ~isempty(d)
	shortnamename = name(1:d(1)-1);
else
	shortname = name;
end
