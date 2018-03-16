% getAllSubFolders.m
% a stupid wrapper around getAllFiles that gets all sub folders from a given folder
% 
% created by Srinivas Gorur-Shandilya at 9:31 , 03 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [all_subfolders,all_files]  = getAllSubFolders(path_name)

% first get all the files
all_files = getAllFiles(path_name);

% then stupidly parse them to figure out the subfolders
all_subfolders =  all_files;
for i = 1:length(all_subfolders)
	temp = strfind(all_subfolders{i},filesep);
	all_subfolders{i} = all_subfolders{i}(1:temp(end));
end

all_subfolders = unique(all_subfolders);


