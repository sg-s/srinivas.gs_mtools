% joinPath
% small utility to join two paths
% works on any operating system
% usage:
% joined_path = joinPath('/wow/so/path','many.txt')

function [c] = joinPath(a,b)

assert(ischar(a),'First argument must be a string')
assert(ischar(b),'2nd argument must be a string')

% remove terminal slash from a
if strcmp(a(end),oss)
	a(end) = [];
end

% remove initial slash from b
if strcmp(b(1),oss)
	b(1) = [];
end

c = [a oss b];


