% returns a path to a place where we can cache data
% safely. This should work even in MATLAB online
% and on all platforms

function cache_path = cachePath(str)


if isempty(userpath)
	userpath('reset');
end

if nargin == 0
	cache_path = userpath;
	return
end

cache_path = fullfile(userpath,str);

if ~exist(cache_path,'dir')
	mkdir(cache_path)
end
