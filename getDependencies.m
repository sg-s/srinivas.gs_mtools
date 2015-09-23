% getDependencies.m
% builds dependency list of functions in a list of folders
% usage
% getDependencies({'folder1','folder2'})
% 
% created by Srinivas Gorur-Shandilya at 3:54 , 03 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = getDependencies(allpaths)

if ~nargin
	help getDependencies
	return
end

% first get the names of all files in all paths
if ~iscell(allpaths)
	temp = allpaths;
	clear allpaths
	allpaths{1} = temp;
end
allfiles = {};
for i = 1:length(allpaths)
	temp = allpaths{i};
	if ~strcmp(temp(end),oss)
		allpaths{i} = [allpaths{i} oss]
	end
	if isdir(allpaths{i})
		these_files = dir([allpaths{i} '*.m']);
		allfiles = [allfiles {these_files.name}];
	else
		allfiles = [allfiles allpaths{i}];
	end
end

allfiles = sort(allfiles);

for i = 1:length(allfiles)
	these_deps = {};
	temp = fileread(allfiles{i});
	disp(['Dependencies for ' allfiles{i}])
	for j = 1:length(allfiles)
		[~,thisfilename] = fileparts(allfiles{j});
		if ~isempty(strfind(temp,thisfilename))
			these_deps = [these_deps; thisfilename];
		end
	end
	disp(these_deps)
	fprintf('\n')
end