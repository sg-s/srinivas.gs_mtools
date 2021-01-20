% pFooter.m
% code meant to be run after the completion of a mfile that is being published
% 
% created by Srinivas Gorur-Shandilya at 1:49 , 16 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

% figure out which file is calling it;
calling_func = dbstack;

if length(length(calling_func)) > 1
	calling_func = calling_func(2).name; % it's always going to be #2 


	pdflib.showDependencyHash(calling_func);
end

