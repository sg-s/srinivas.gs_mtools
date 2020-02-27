% pathlib.lowestFolder
% returns the lowest-level folder from the path
% not the root, the other end
%
function folder_name = lowestFolder(p)

assert(exist(p,'file') ~= 0 ,'Path does not resolve')

p = strsplit(p,filesep);

if isempty(p{end})
	folder_name = p{end-1};
else
	folder_name = p{end};
end