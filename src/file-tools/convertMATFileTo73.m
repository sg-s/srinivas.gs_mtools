% convertMATFileTo73.m
% converts a MATFile to v7.3
% 
% created by Srinivas Gorur-Shandilya at 1:18 , 04 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = convertMATFileTo73(path_to_file)


if any(strfind(path_to_file,'*'))
	% attempt to find all the files that match this, and run recursively on this list
	allfiles = dir(path_to_file);
	for i = 1:length(allfiles)
		convertMATFileTo73(allfiles(i).name);
	end
	return
end

assert(any(exist(path_to_file,'file')),'Input argument must be a valid path to a MATLAB .mat file')

version_number = findMATFileVersion(path_to_file);
if version_number == 7.3
	return
end

% load all the variables and re-save 
load(path_to_file,'-mat');
clear version_number 
variable_names = whos;
variable_names(find(strcmp('path_to_file',{variable_names.name}))) = [];
eval_str = ['savefast(', char(39), path_to_file, char(39)];
for i = 1:length(variable_names)
	eval_str = [eval_str, ',', char(39), variable_names(i).name, char(39)];
end
eval_str = [eval_str ')'];
eval(eval_str)
