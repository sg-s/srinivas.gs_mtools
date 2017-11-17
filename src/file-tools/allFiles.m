% returns a list of all files in the specified path
% if no input is give, uses the cwd
% the advantage of this over the built in dir
% is that it skips junk like hidden files, etc. 

function allfiles = allFiles(path_to_search)

if nargin < 1
	path_to_search = pwd;
end

allfiles = dir(path_to_search);
rm_this = false(length(allfiles));
for i = 1:length(allfiles)
	if strcmp(allfiles(i).name(1),'.')
		rm_this(i) = true;
	end
	if allfiles(i).isdir
		rm_this(i) = true;
	end
end
allfiles(rm_this) = [];
allfiles = {allfiles.name};