% checks is a newer version is available on bitbucket
% created by Srinivas Gorur-Shandilya at 15:16 on 31-March-2014. Contact me at http://srinivas.gs/
% part of srinivas.gs_mtools
function [m] = CheckForNewestVersionOnBitBucket(filename,VersionName)
a = strfind(VersionName,'v_');
z = strfind(VersionName,'_');
z = setdiff(z,a+1);
old_vn = str2double(VersionName(a+2:z-1));

h = urlread(strcat('https://bitbucket.org/srinivasgs/',lower(filename),'/'));

% get links
[a,ra]=GetLinks(h);
fullname = strcat(filename,'.m');

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
	warning('A newer version of Kontroller is available. It is a really good idea to upgrade. Download it  <a href="https://bitbucket.org/srinivasgs/kontroller">here</a> .')
end
