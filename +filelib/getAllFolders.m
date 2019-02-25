%% getAllFolders
% gets all folders in a given folder, recursively searching the entire tree
% 
% usage:
% 
% all_folders = getAllFolders('/path/to/search/')
% 
% where all_folders is a cell array
% 

function [all_folders] = getAllFolders(path_name)

if ~nargin
	help getAllFolders
	return
end

temp = genpath(path_name);
breakpoints = [0 strfind(temp,pathsep)];
all_folders = cell(length(breakpoints)-1,1);
for i = 1:length(breakpoints)-1
	all_folders{i} = temp(breakpoints(i)+1:breakpoints(i+1)-1);
end