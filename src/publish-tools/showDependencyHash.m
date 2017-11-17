% showDependencyHash
% shows the repository name and git commit hash of all dependencies in a given m file 
% 
% created by Srinivas Gorur-Shandilya at 2:39 , 15 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = showDependencyHash(this_file)

assert(ischar(this_file),'input argument should be a string')
assert(exist(this_file,'file')==2,'file not found.')

original_folder = pwd;

% intelligently search the path and make a list of m files that are likely to be user-generated
p = path;
p = [pathsep p];
c = strfind(p,pathsep);

% augment the path with folders beginning with a @ within those folders
pp = '';

for i = 2:length(c)
	this_folder = p(c(i-1)+1:c(i)-1);
	if ~any(strfind(this_folder,'MATLAB_R'))
		class_folders = dir([this_folder oss '@*']);
		for j = 1:length(class_folders)
			pp = [pp pathsep class_folders(j).folder oss class_folders(j).name];
		end
	end
end

p = [pp p];
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

% find the functions that this file depends on
dep_files = allfiles(isDep(lineRead(which(this_file)),allfiles));

% we now have a bunch of dependencies. now look one level down -- at the dependencies of the dependencies 
is_dep = false(length(allfiles),1);
for j = 1:length(dep_files)
	try
		is_dep = is_dep + isDep(lineRead(which(dep_files{j})),allfiles);
	catch
		% one reason for an error here is that there is a method called "plot" in a class that is on the path, but "plot" also exists in a protected MATLAB workspace, and which(plot) resolves to the MATLAB builtin, not the class method
	end
end
is_dep(is_dep>0) = 1;
dep_files =  unique([dep_files allfiles(logical(is_dep))]);

% remove default and some other files to ignore
dep_files(strcmp('default',dep_files)) = [];
dep_files(strcmp('temp',dep_files)) = [];
dep_files(strcmp('finish',dep_files)) = [];


% find which folders they are in
allfolders = {};
for i = 1:length(dep_files)
	this_folder = fileparts(which(dep_files{i}));

	allfolders = [allfolders this_folder];
end
allfolders = unique(allfolders);

% which of these are git repos, or are contained in git repos? 
is_git = false(length(allfolders),1);
git_folder_name = {};
for i = 1:length(allfolders)
	this_folder = allfolders{i};

	% make sure this folder is not a MATLAB classdef folder
	if any(strfind(this_folder,'@'))
		continue
	end

	if exist([this_folder oss '.git'],'file') == 7
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

for i = 1:length(allfolders)
	repo_name = allfolders{i}(max(strfind(allfolders{i},oss))+1:end);
	cd(allfolders{i})

	% check if there are any uncommitted files here
	[~,m] = unix('git status | grep "modified" | wc -l');
	if str2double(m) > 0 
		warning(['You have unmodified files that have not been committed on this git repo: ' allfolders{i}])

	end


	[status,m] = system('git rev-parse HEAD');
	if ~status
		disp(['repo name:  ' repo_name ' (' m(1:end-1) ')'])
	end
end

% go back from whence you came
cd(original_folder)


