% getAllFiles.m
% recursively get all files from a specific directory 
% from:
% http://stackoverflow.com/questions/2652630/how-to-get-all-files-under-a-specific-directory-in-matlab
% usage: fileList = getAllFiles(dirName)
function fileList = getAll(dirName)
if ~nargin 
	help filelib.getAll
	fileList = {};
	return
end
dirData = dir(dirName);      % Get the data for the current directory
dirIndex = [dirData.isdir];  % Find the index for directories
fileList = transpose({dirData(~dirIndex).name});
if ~isempty(fileList)
	fileList = cellfun(@(x) fullfile(dirName,x), fileList, 'UniformOutput',false);
end
subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
                                             %   that are not '.' or '..'
for iDir = find(validIndex)                  % Loop over valid subdirectories
	nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
	
	fileList = [fileList; filelib.getAll(nextDir)];  % Recursively call getAllFiles

end

