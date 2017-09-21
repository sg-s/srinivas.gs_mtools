% lineWrite.m
% the opposite of lineRead.m
% writes lines to a text file
% where lines is a cell array

function lineWrite(file_name,lines)

assert(ischar(file_name),'First argument should be a string')
assert(iscell(lines),'2nd argument should be a cell array')

fileID = fopen(file_name,'w');
for i = 1:length(lines)
	fprintf(fileID, [lines{i} '\n']);
end
fclose(fileID);