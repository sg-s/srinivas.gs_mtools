% extracts code blocks from a markdown-formatted
% text file
% this is useful for automating testing
% of documentation
% 
function code_blocks = extractCodeBlocks(path_to_file, code_fence_syntax)

if nargin < 2
	code_fence_syntax = '```matlab';
end

assert(exist(path_to_file,'file') == 2,'File does not exist')

lines = filelib.read(path_to_file);

code_block_starts = find(cellfun(@(x) strcmp(x,'```matlab'),lines));
code_block_stops = find(cellfun(@(x) strcmp(x,'```'),lines));

if isempty(code_block_starts)
	code_blocks = [];
	return
end

for i = length(code_block_starts):-1:1
	z = code_block_stops(find(code_block_stops > code_block_starts(i),1,'first'));
	a = code_block_starts(i);

	code_blocks(i).lines = lines(a+1:z-1);

end

