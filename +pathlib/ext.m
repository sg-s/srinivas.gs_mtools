% ext.m
% returns the terminal bit of a path, e.g.
% the last folder or file in a path
% usage:
% file_name = pathEnd('path/to/file_name')
% 
function ext_name = ext(p)

if iscell(p)
	ext_name = p;
	for i = 1:length(p)
		ext_name{i} = pathlib.ext(p{i});
	end
	return
end

% first, make sure this exists
assert(exist(p,'file') > 0 || exist(p,'file') == 2,['Path does not resolve: ' p])

[~,~,ext_name] = fileparts(p);


