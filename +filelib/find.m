% filelib.find.m
% finds patterns in lines of text
% lines is a cell array, for example, if 
% lines is from lineRead();
% also supports wildcard matching using regex

function idx = find(lines,pattern)

idx = [];
if any(strfind(pattern,'*'))
	regStr = ['^',strrep(strrep(pattern,'?','.'),'*','.{0,}'),'$'];
	starts = regexpi(lines, regStr);
	iMatch = ~cellfun(@isempty, starts);
	idx = find(iMatch);
else

	for i = 1:length(lines)
		if strfind(strtrim(lines{i}),pattern)
			idx = [idx; i];
		end
	end
end
