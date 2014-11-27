% checks is a newer version of a given files is available on bitbucket
% checks for a pattern containing version number in the source code.
% assumes open source code on bitbucket.org
% this is of rather limited use right now
% usage:
% m = CheckForNewestVersionOnBitBucket(filename,VersionName,fullname)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function m = CheckForNewestVersionOnBitBucket(filename,VersionName,fullname)
if ~nargin
	help CheckForNewestVersionOnBitBucket
	return
end	
a = strfind(VersionName,'v_');
z = strfind(VersionName,'_');
z = setdiff(z,a+1);
old_vn = str2double(VersionName(a+2:z-1));

u = strcat('https://bitbucket.org/srinivasgs/',lower(filename),'/src/');
h = urlread(u);

% get links
[a,ra]=GetLinks(h);
if nargin < 3
	fullname = strcat(filename,'.m');
end
for i = 1:length(ra)
	if ~isempty(strfind(ra{i},fullname))
		h = ra{i};
	end
end

h = strcat('https://bitbucket.org',h);
% now get this page
mtext = urlread(h);

lookhere=strfind(mtext,'VersionName');
lookhere = lookhere(1);
lookhere = mtext(lookhere:lookhere+100);
a = strfind(lookhere,'v_');
z = strfind(lookhere,'_');
z = setdiff(z,a+1);

online_vn = str2double(lookhere(a+2:z-1));

if online_vn > old_vn
	warningtext = strkat('A newer version of ',filename,' is available. It is a really good idea to upgrade. Download it  <a href="',u,'">here</a>.');
	disp(warningtext)
else
	disp('Checked for updates, no updates available.')
    
end
