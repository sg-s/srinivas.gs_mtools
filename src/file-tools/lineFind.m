% lineFind.m
% finds patterns in lines of text, ignoring spaces
% lines is a cell array, for example, if 
% lines is from lineRead();
function idx = lineFind(lines,pattern)
idx = [];
for i = 1:length(lines)
	if strcmp(pattern,strtrim(lines{i}))
		idx = [idx; i];
	end
end