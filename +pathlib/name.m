% name.m
% returns the terminal bit of a path, e.g.
% the last folder or file in a path
% usage:
% file_name = pathEnd('path/to/file_name')
% 
function [file_name] = ext(p)

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


