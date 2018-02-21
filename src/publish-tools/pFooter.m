% pFooter.m
% code meant to be run after the completion of a mfile that is being published
% 
% created by Srinivas Gorur-Shandilya at 1:49 , 16 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

% figure out which file is calling it;
calling_func = dbstack;
calling_func = calling_func(2).name; % it's always going to be #2 
disp(calling_func)

try
	disp('md5 hash of file that made this is:')
	Opt.Input = 'file';
	disp(dataHash(strcat(calling_func,'.m'),Opt))
catch
end

disp('it should be in this commit:')
status = false;
[status,m] = system('git rev-parse HEAD');
if ~status
	disp(m)
else
	disp('Error reading git commit.')
end

disp('This file has the following external dependencies:')
showDependencyHash(calling_func);

t = toc;

disp('This document was built in:')
disp(strcat(oval(t,3),' seconds.'))
