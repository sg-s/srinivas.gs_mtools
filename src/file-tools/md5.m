% md5.m
% returns md5 hash for anything you throw at it
% for files, md5 uses system md5 (which is 2x faster than the one in dataHash, but falls back to dataHash if it fails)
function [hash] = md5(file)
if exist(file,'file') == 2	
	[status,hash] = system(['md5 "' file '"']);
	if status == 0
		hash = hash((strfind(hash,'='))+2:end-1);
	else
		Opt.Input = 'file';
		hash = dataHash(file,Opt);
	end
	
else
	hash = dataHash(file);
end
	