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
% cache(hash,[]) clears that value from the hash table
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

maxCacheSize = 100e9; % in bytes

root = [pwd oss];

hash = '';
% check if cache exists
if exist(strcat(root,'cached.mat'),'file')
	try
		load(strcat(root,'cached.mat'),'hash') % only load the hashes, it's much faster
	catch err
		if any(strfind(err.message,'corrupt'))
			% corrupt cache. use a global cache
			[~,root]=searchpath('mtools');
			root = [root oss];
			warning('Local cache is corrupted. Falling back to global cache...')
			% check if there is a global cache
			if ~exist([root cached.mat],'file')
				save(strcat(root,'cached.mat'),'hash');
			end
		end
	end
else
	save(strcat(root,'cached.mat'),'hash')
end


if nargin == 1
	if isempty(find(strcmp(varargin{1}, hash)))
		retrieved_data = [];
		return
	else
		temp=load(strcat(root,'cached.mat'),strcat('md5_',varargin{1}));
		eval(strcat('retrieved_data=temp.md5_',varargin{1},';'))

		% update retrieval time stamp
		load(strcat(root,'cached.mat'),'last_retrieved');
		if ~exist('last_retrieved')
			last_retrieved = zeros(length(hash),1);
		end
		last_retrieved(find(strcmp(varargin{1}, hash))) = now;
		save(strcat(root,'cached.mat'),'last_retrieved','-append')

	end
end

if nargin == 2
	if isempty(find(strcmp(varargin{1}, hash)))
		wh = length(hash)+1; % write here
		hash{wh}=varargin{1};
		eval(strcat('md5_',varargin{1},'=varargin{2};'));
		save(strcat(root,'cached.mat'),'hash',strcat('md5_',hash{wh}),'-append')
	else
		if isempty(varargin{2})
			% set that data entry to empty
			eval(strcat('md5_',varargin{1},'=[];'))
			% and remove the hash from the hash table
			hash(find(strcmp(varargin{1}, hash))) = [];
			save(strcat(root,'cached.mat'),'hash',strcat('md5_',varargin{1}),'-append')
		end
	end
end

% trim cache
s = dir(strcat(root,'cached.mat'));
while s.bytes - maxCacheSize > 0
	clear last_retrieved temp hash
	temp = load(strcat(root,'cached.mat'),'last_retrieved','hash');
	last_retrieved = temp.last_retrieved;
	hash = temp.hash;

	% delete the oldest-looked-at hash
	[~,rm_this]=min(last_retrieved-now);
	rm_this_hash = hash{rm_this};
	eval(strcat('md5_',rm_this_hash,'=[];'))

	hash(rm_this) = [];
	save(strcat(root,'cached.mat'),'hash',strcat('md5_',rm_this_hash),'-append')
	warning('cache-Pruning cache...')

	s = dir(strcat(root,'cached.mat'));
end
