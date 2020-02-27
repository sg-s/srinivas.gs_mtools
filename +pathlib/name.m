% name.m
% returns the name from fileparts
% 
function [file_name] = name(p)

if iscell(p)
	file_name = p;
	for i = 1:length(p)
		file_name{i} = pathlib.name(p{i});
	end
	return
end

% first, make sure this exists
assert(exist(p,'file') == 7 || exist(p,'file') == 2,'Path does not resolve')

[~,file_name] = fileparts(p);


