% utility function that checks a .mat
% for a hash and if it matches a certain value
% returns true
% usage:
%
% TF = filelib.cacheOK(cache_loc,H)
%
% TF is false if cache_loc does not exist
% TF is false if cache_loc does not contain a variable called "hash"
% TF is false if the variable "hash" in that file does not match the argument hash
% TF true otherwise
% When TF is true, you know you can use the contents of that file
% and the cache isn't stale

function TF = cacheOK(cache_loc, H)

TF = false;

if exist(cache_loc,'file') ~= 2
	return
end

try load(cache_loc,'hash')
catch
	return
end

if strcmp(hash,H)
	TF = true;
end




