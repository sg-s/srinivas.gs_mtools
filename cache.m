% cache.m
% fast, hash-based cache function to speed up computation. 
% cache(hash) retrieves the data Y corresponding to the hash of data X
% e.g.,
% if Y = some_function(X);, and if some_function is computationally expensive,
% cache the results using
% cache(DataHash(X),Y);
% and
% retrieve them later using
% Y = cache(DataHash(X));
% 
% created by Srinivas Gorur-Shandilya at 8:31 , 28 January 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function []  = cache(varargin)

switch nargin
	case 0
		help cache
		return
	case 1
	case 2
	otherwise
		help cache
		error('Too many input arguments.')
end

% check if cache exists
if exist('cached.mat','file')
	load('cached.mat')
else
	cached(1).md5 = '';
	cached(1).data = [];
	save('cached.mat','cached')
end


if nargin == 1
	console('retrieval mode')
	keyboard
end

if nargin == 2
	console('write to hash table mode')
	keyboard
end

