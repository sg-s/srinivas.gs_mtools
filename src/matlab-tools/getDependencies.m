% getDependencies.m
% gets all the dependencies of a given mfile
% usage:
% getDependencies(file_name)
% 
% created by Srinivas Gorur-Shandilya at 3:54 , 03 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function deps = getDependencies(this_file)

if ~nargin
	help getDependencies
	return
end

assert(ischar(this_file),'input argument should be a string')
assert(exist(this_file,'file')==2,'file not found.')

% intelligently search the path and make a list of m files that are likely to be user-generated
p = path;
p = [pathsep p];
c = strfind(p,pathsep);

allfiles = {};

% add all class definition folders to the path
pp = '';
for i = 2:length(c)
	this_folder = p(c(i-1)+1:c(i)-1);

	% look for class definition folders
	if ~any(strfind(this_folder,'MATLAB_R'))
		d = dir(this_folder);
		isub = [d(:).isdir]; 
		sub_folders = {d(isub).name}';
		sub_folders(ismember(sub_folders,{'.','..'})) = [];
		if ~isempty(sub_folders)
			% find the sub_folders beginning with a @
			for j = 1:length(sub_folders)
				if strcmp(sub_folders{j}(1),'@')
					pp = [pp pathsep this_folder filesep sub_folders{j}];
				end
			end
		end
	end
end

p = [p pp];
c = [strfind(p,pathsep) length(p)+1];

% get the name of all the files in the path
for i = 2:length(c)
	this_folder = p(c(i-1)+1:c(i)-1);
	if ~any(strfind(this_folder,'MATLAB_R'))
		files_in_this_folder = dir([this_folder filesep '*.m']);
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
deps = allfiles(is_dep);
deps = deps(:);

