% checkForNewestVersionOnGitHub.m
% checks for newest version of a given repo or file on github. 
% works by looking for a file called "build_number" on the repo root and comparing it to what is available locally
% 
% v = checkForNewestVersionOnGitHub(repo)
% for example
% v = checkForNewestVersionOnGitHub('sg-s/spikesort')
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function v = checkForNewestVersionOnGitHub(repo)
if ~nargin 
	help checkForNewestVersionOnGitHub
	return
end

try
	if ~strcmp(repo(end),'/')
		repo = [repo '/'];
	end
	if ~strcmp(repo(1),'/')
		repo = ['/' repo];
	end
	u = ['https://raw.githubusercontent.com' repo 'master/build_number'];
	v = str2double(webread(u));
catch
	warning('Could not connect to GitHub')
	v = NaN;
end
