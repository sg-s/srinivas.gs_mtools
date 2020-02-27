% findMATFileVersion.m
% determines the version of a mat file (cannot resolve v6 from v7)
% 
% created by Srinivas Gorur-Shandilya at 1:01 , 04 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [version_number] = findMATFileVersion(path_to_file)

if any(strfind(path_to_file,'*'))
	% attempt to find all the files that match this, and run recursively on this list
	allfiles = dir(path_to_file);
	version_number = NaN(length(allfiles),1);
	for i = 1:length(allfiles)
		version_number(i) = findMATFileVersion(allfiles(i).name);
	end
	return
end

assert(any(exist(path_to_file,'file')),'Input argument must be a valid path to a MATLAB .mat file')
% from https://stackoverflow.com/questions/29379826/how-can-i-determine-the-version-of-a-mat-file-from-matlab
fid=fopen(path_to_file);
txt=char(fread(fid,[1,140],'*char'));
txt=[txt,0];
txt=txt(1:find(txt==0,1,'first')-1); 

if isempty(txt)
	version_number = 4;
	return
elseif any(strfind(txt,'7.3'))
	version_number = 7.3;
	return
else
	version_number = 7;
	return
end