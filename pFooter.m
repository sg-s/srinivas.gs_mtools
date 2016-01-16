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

%%
% and its md5 hash is:
Opt.Input = 'file';
disp(dataHash(strcat(calling_func,'.m'),Opt))

%%
% This file should be in this commit:
status = false;
[status,m] = system('git rev-parse HEAD');
if ~status
	disp(m)
end

%%
% This file has the following external dependencies:
showDependencyHash(calling_func);

t = toc;

%% 
% This document was built in: 
disp(strcat(oval(t,3),' seconds.'))

% tag the file as being published (only on Mac OS X)
if being_published
	if ismac
		try
			unix(['tag -a published ',which(calling_func)]);
			unix(['tag -r publish-failed ',which(calling_func)]);
		catch
		end
	end
end