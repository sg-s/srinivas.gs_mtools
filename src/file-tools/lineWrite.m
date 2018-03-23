% lineWrite.m
% the opposite of lineRead.m
% writes lines to a text file
% where lines is a cell array

function lineWrite(file_name,lines)

assert(ischar(file_name),'First argument should be a string')
assert(iscell(lines),'2nd argument should be a cell array')

fileID = fopen(file_name,'w');

if ispc
	
	for i = 1:length(lines)
		this_line = strrep(lines{i},'%','%%');
		fprintf(fileID, [this_line '\r\n']);
	end

else
	for i = 1:length(lines)
		this_line = strrep(lines{i},'%','%%');
		fprintf(fileID, [this_line '\n']);
	end
	
end


fclose(fileID);