% checkForNewestVersionOnGitHub.m
% checks for newest version of a given repo or file on github. 
% 
% usage: m = checkForNewestVersionOnGitHub(reponame,filename,VersionName)
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function m = checkForNewestVersionOnGitHub(reponame,filename,VersionName)
if ~nargin 
	help checkForNewestVersionOnGitHub
	return
end
a = strfind(VersionName,'v_');
z = strfind(VersionName,'_');
z = setdiff(z,a+1);
old_vn = str2double(VersionName(a+2:z-1));


u = strcat('https://raw.githubusercontent.com/sg-s/',lower(reponame),'/master/',filename,'.m');

h = urlread(u);

lookhere=strfind(h,'VersionName');
lookhere = lookhere(1);
lookhere = h(lookhere:lookhere+100);
a = strfind(lookhere,'v_');
z = strfind(lookhere,'_');
z = setdiff(z,a+1);

online_vn = str2double(lookhere(a+2:z-1));

if online_vn > old_vn
	warningtext = strkat('A newer version of ',filename,' is available. It is a really good idea to upgrade.');
	disp(warningtext)
	m = 1;
else
	disp('Checked for updates, no updates available.')
	m = 0;
    
end