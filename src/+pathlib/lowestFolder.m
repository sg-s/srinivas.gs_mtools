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



if isdir(p)

	p = strsplit(p,filesep);

	if isempty(p{end})
		folder_name = p{end-1};
	else
		folder_name = p{end};
	end

	assert(exist(strjoin(p(1:end-1),filesep),'file') ~= 0 ,'Path does not resolve')

else
	folder_name = pathlib.lowestFolder(fileparts(p));

end