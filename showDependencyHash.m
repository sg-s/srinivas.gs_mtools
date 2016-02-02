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

% search the file in question for these keywords
% read the source file line by line
fid = fopen(which(this_file), 'rt'); 
source_code = textscan(fid,'%[^\n]'); %reads line by line 
source_code = source_code{1};
is_dep = false(length(allfiles),1);

for i = 1:length(allfiles)
	for j = 1:length(source_code)
		if any(strfind(source_code{j},allfiles{i}))
			temp = strfind(source_code{j},allfiles{i});
			temp = temp(1); % this is to account for two invocations of one function in 1 line
			% keyword in this line
			if any(strfind(source_code{j},'%'))
				% there is a % somewhere 
				if temp < strfind(source_code{j},'%')
					% keyword is not a comment
					is_dep(i) = true;
				else
					% keyword is a comment. do nothing
				end
			else
				% no % anywhere, but keyword present
				is_dep(i) = true;
			end
		end
	end
end
dep_files = allfiles(is_dep);


% we now have a bunch of dependencies. now look one level down -- at the dependencies of the dependencies 
is_dep = false(length(allfiles),1);
for j = 1:length(dep_files)
	source_code = fileread(which(dep_files{j}));
	for i = 1:length(allfiles)
		if any(strfind(source_code,allfiles{i}))
			is_dep(i) = true;
		end
	end
end
dep_files =  unique([dep_files allfiles(is_dep)]);


% find which folders they are in
allfolders = {};
for i = 1:length(dep_files)
	allfolders = [allfolders fileparts(which(dep_files{i}))];
end
allfolders = unique(allfolders);

% which of these are git repos?
for i = 1:length(allfolders)
	if exist([allfolders{i} oss '.git'],'file') == 7
		repo_name = allfolders{i}(max(strfind(allfolders{i},oss))+1:end);
		cd(allfolders{i})
		[status,m]=system('git rev-parse HEAD');
		if ~status
			disp(['repo name:  ' repo_name '  commit:   ' m(1:7)])
		end
	end
end

% go back from whence you came
cd(original_folder)






