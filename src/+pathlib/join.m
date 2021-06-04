% joinPath
% small utility to join strings together
% so that they form a valid path
% works on any operating system
% usage:
% joined_path = joinPath('/wow/so/path','doge','many.txt')

function c = join(varargin)

for i = 1:length(varargin)
	assert(ischar(varargin{i}),'argument must be a string')
end

c = [];
for i = 1:length(varargin)
	if strcmp(varargin{i}(end),filesep)
		varargin{i}(end) = [];
	end
	c = [c varargin{i} filesep];
end

c(end)  = [];
