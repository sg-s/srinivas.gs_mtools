% showDependencyHash
% shows the repository name and git commit hash of all dependencies in a given m file 
% 
% created by Srinivas Gorur-Shandilya at 2:39 , 15 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = isCodeCommitted()


original_folder = pwd;

% intelligently search the path and make a list of m files that are likely to be user-generated
p = path;
p = [pathsep p];
c = strfind(p,pathsep);

allfiles = {};

for i = 2:length(c)
	this_folder = p(c(i-1)+1:c(i)-1);
	if ~any(strfind(this_folder,'MATLAB_R'))
		files_in_this_folder = dir([this_folder oss '*.m']);
		allfiles = [allfiles files_in_this_folder.name];
	end
end

% strip extention for each of these files
for i = 1:length(allfiles)
	allfiles{i} = allfiles{i}(1:end-2);
end

dep_files = allfiles;

% find which folders they are in
allfolders = {};
for i = 1:length(dep_files)
	allfolders = [allfolders fileparts(which(dep_files{i}))];
end
allfolders = unique(allfolders);

% which of these are git repos, or are contained in git repos? 
is_git = false(length(allfolders),1);
git_folder_name = {};
for i = 1:length(allfolders)
	this_folder = allfolders{i};

	if exist([allfolders{i} oss '.git'],'file') == 7
		is_git(i) = true;
		git_folder_name{i} = this_folder;
	else
		% look up 10 levels
		for j = 1:10
			this_folder = fileparts(this_folder);
			if exist([this_folder oss '.git'],'file') == 7
				is_git(i) = true;
				git_folder_name{i} = this_folder;
				continue;
			end
		end 
	end
end
allfolders =  unique(git_folder_name(is_git)');

ok = true;

for i = 1:length(allfolders)
	repo_name = allfolders{i}(max(strfind(allfolders{i},oss))+1:end);
	cd(allfolders{i})

	% check if there are any uncommitted files here
	[~,m] = system('git status --porcelain | wc -l');
	if str2double(m) > 0 
		cprintf('red','MODIFIED  ')
		cprintf('text',[repo_name '\n'])
		ok = false;
	else
		cprintf('green','OK        ')
		cprintf('text',[repo_name '\n'])
	end

end

% go back from whence you came
cd(original_folder)
fprintf('\n')

assert(ok,'Uncommitted changes in your code; refusing to shut down.')



