% pHeader.m
% scriptable code to be executed before a mfile is published
% 
% created by Srinivas Gorur-Shandilya at 1:42 , 16 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

path1 = getenv('PATH');
if ispc
	% add path for git
	if isempty(strfind(path1,'C:\Progam Files\Git\cmd'))
	    path1 = [path1 pathsep 'C:\Progam Files\Git\cmd'];
	end
	setenv('PATH', path1);
elseif ismac 
	% add homebrew paths -- assuming git installed using http://brew.sh
	if isempty(strfind(path1,':/usr/local/bin'))
	    path1 = [path1 pathsep '/usr/local/bin'];
	end
	setenv('PATH', path1);
else
	error('Im too lazy to write this section for GNU/Linux. Please send me a PR.')
end

% common code
calling_func = dbstack;
being_published = 0;
if ~isempty(calling_func)
	if find(strcmp('publish',{calling_func.name}))
		being_published = 1;
		if ismac
			try
				[e,~] = unix('tag');
				if e == 0
					unix(['tag -a publish-failed ',which(mfilename)]);
					unix(['tag -r published ',which(mfilename)]);
				end
			catch
				% probably no tag. no big deal.
			end
		end
	end
end

tic