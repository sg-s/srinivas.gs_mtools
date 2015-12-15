% stripPath.m
% strips the path from a complete path to a file
% i.e., returns the directory that contains the file in the string
function [p f] = stripPath(s)
if ~nargin
	help stripPath
	return
end

p = regexp(s,oss);
if ~isempty(p)
    f = s(p(end)+1:end);
    p = s(1:p(end));
else
    f = s;
end