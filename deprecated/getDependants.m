% getDependants.m
% builds reverse-dependency list of functions in a list of folders
% usage
% getDependants({'folder1','folder2'})
% 
% created by Srinivas Gorur-Shandilya at 3:54 , 03 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = getDependants(allpaths)

if ~nargin
	help getDependants
	return
end

% first get the names of all files in all paths
if ~iscell(allpaths)
	temp = allpaths;
	clear allpaths
	allpaths{1} = temp;
end

allfiles = {};
parent_folder = {};

for i = 1:length(allpaths)
	temp = allpaths{i};
	
	if isdir(allpaths{i})
		if ~strcmp(temp(end),filesep)
			allpaths{i} = [allpaths{i} filesep];
		end
		these_files = dir([allpaths{i} '*.m']);
		allfiles = [allfiles {these_files.name}];
		parent_folder = [parent_folder ; repmat(allpaths(i),length(these_files),1)];
	else
		[a,b,c]=fileparts(allpaths{i});
		allfiles = [allfiles [b c]];
		parent_folder = [parent_folder ; [a filesep]];
	end
end



for i = 1:length(allfiles)
	these_deps = {};

	thisfilename = strrep(allfiles{i},'.m','');
	
	for j = setdiff(1:length(allfiles),i)
		temp = fileread([parent_folder{j} allfiles{j}]);
		
		if any(strfind(temp,thisfilename))
			these_deps = [these_deps; allfiles{j}];
		end
	end
	if length(these_deps)
		disp(['The following files rely on ' allfiles{i} ' to work:'])
		disp(these_deps)
		fprintf('\n')
	else
		disp([allfiles{i} ' has no dependants.'])
		fprintf('\n')

	end
	
	
end