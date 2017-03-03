% uses system md5 for fast file hashing (2x faster than dataHash)
function [hash] = md5(file)
[status,hash] = system(['md5 "' file '"']);
if status ~= 0
	error('md5 failed')
end
hash = hash((strfind(hash,'='))+2:end-1);