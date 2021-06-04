% gitHash.m
% finds the hash of the current commit of the git repository of the given file
% usage: 
% h = gitHash(filename);
% finds the hash of the current commit of the git repository of the given file
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function h = gitHash(filename)
switch nargin
case 0
	help gitHash
	return
end

slashes = strfind(filename,filesep);

if isempty(slashes)
	h = '000000';
else

	root = filename(1:slashes(end));

	try
		h=fileread(strcat(root,'.git',filesep,'refs',filesep,'heads',filesep,'master'));
		h = h(1:40);
	catch
		h = '000000';
	end
end