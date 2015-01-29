% cache.m
% fast, hash-based cache function to speed up computation. 
% cache(hash) retrieves the data Y corresponding to the hash of data X
% 
% if Y = some_function(X);, and if some_function is computationally expensive,
% cache the results using
% cache(DataHash(X),Y);
% 
% and retrieve them later using
% Y = cache(DataHash(X));
%
% cache respects Idempotence (https://en.wikipedia.org/wiki/Idempotent)
% so cache(DataHash(X),Y); cache(DataHash(X),Y);
% will only write to file once. this also means that hashes exist uniquely in the cache
% 
% 
% created by Srinivas Gorur-Shandilya at 8:31 , 28 January 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function retrieved_data  = cache(varargin)

switch nargin
	case 0
		help cache
		% also show the hashes we have
		try
			load('cached.mat','hash')
			disp('Here is a list of hashes in the current hash table:')
			disp(hash')
		catch
		end
		return
	case 1
	case 2
	otherwise
		help cache
		error('Too many input arguments.')
end

maxCacheSize = 100e6; % in bytes

% check if cache exists
if exist(strcat(pwd,oss,'cached.mat'),'file')
	load(strcat(pwd,oss,'cached.mat'),'hash') % only load the hashes, it's much faster
else
	hash = '';
	save(strcat(pwd,oss,'cached.mat'),'hash')
end


if nargin == 1
	if isempty(find(strcmp(varargin{1}, hash)))
		retrieved_data = [];
		return
	else
		temp=load(strcat(pwd,oss,'cached.mat'),strcat('md5_',varargin{1}));
		eval(strcat('retrieved_data=temp.md5_',varargin{1},';'))
	end
end

if nargin == 2
	if isempty(find(strcmp(varargin{1}, hash)))
		wh = length(hash)+1; % write here
		hash{wh}=varargin{1};
		eval(strcat('md5_',varargin{1},'=varargin{2};'));
		save(strcat(pwd,oss,'cached.mat'),'hash',strcat('md5_',hash{wh}),'-append')
	end
end

