% pathlib.lowestFolder
% returns the lowest-level folder from the path
% not the root, the other end
%
function folder_name = lowestFolder(p)

if iscell(p)

	for i = length(p):-1:1
		folder_name{i} = pathlib.lowestFolder(p{i});
	end

	return
end

assert(exist(p,'file') ~= 0 ,'Path does not resolve')

p = strsplit(p,filesep);

if isempty(p{end})
	folder_name = p{end-1};
else
	folder_name = p{end};
end