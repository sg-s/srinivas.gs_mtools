% lineFind.m
% finds patterns in lines of text
% lines is a cell array, for example, if 
% lines is from lineRead();
function idx = lineFind(lines,pattern)
idx = [];
for i = 1:length(lines)
	if strfind(strtrim(lines{i}),pattern)
		idx = [idx; i];
	end
end