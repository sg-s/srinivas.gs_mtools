%% getUserPath
% returns the user path of the path
% you would imagine userpath does this, but it doesn't
% 
function [p] = getUserPath()

% get MATLAB name and version
v = version;
v  = v(strfind(v,'(')+1:strfind(v,')')-1);

p = path;
p = [pathsep p pathsep];
s = strfind(p,pathsep);

rs = false(length(p),1);

for i = 1:length(s)-1
	a = s(i);
	z = s(i+1)-1;
	if  ~isempty(strfind(p(a:z),v))
		rs(a:z) = true;
	end
end

p(rs) = [];
p(1) = [];
p(end) = [];