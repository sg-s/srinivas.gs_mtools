% cache.m
% fast, hash-based cache function to speed up computation. 
% cache(hash) retrieves the data Y corresponding to the hash of data X
% 
% if Y = some_function(X);, and if some_function is computationally expensive,
% cache the results using
% cache(dataHash(X),Y);
% 
% and retrieve them later using
% Y = cache(dataHash(X));
%
% cache respects Idempotence (https://en.wikipedia.org/wiki/Idempotent)
% so cache(dataHash(X),Y); cache(dataHash(X),Y);
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
			temp = setdiff(hash,'hash');
			disp(temp(:))
		catch
		end
		return
	case 1
	case 2
	otherwise
		help cache
		error('Too many input arguments.')
end

maxCacheSize = 1000; % in MB

root = [pwd filesep];

hash = '';
% check if cache exists
if exist(strcat(root,'cached.mat'),'file')
	try
		load(strcat(root,'cached.mat'),'hash') % only load the hashes, it's much faster
	catch err
		if any(strfind(err.message,'corrupt'))
			% corrupt cache. use a global cache
			[~,root]=searchpath('mtools');
			root = [root filesep];
			warning('Local cache is corrupted. Falling back to global cache...')
			% check if there is a global cache
			if ~exist(strcat(root,'cached.mat'),'file')
				save(strcat(root,'cached.mat'),'hash');
				disp('Initialised global cache...')
			else
				load(strcat(root,'cached.mat'),'hash');
			end
		end
	end
else
	save(strcat(root,'cached.mat'),'hash')
end


if nargin == 1

	assert(length(varargin{1}) < 50,'hash too long, cannot be stored in hash table')

	if isempty(find(strcmp(varargin{1}, hash)))
		retrieved_data = [];
		return
	else
		temp = load(strcat(root,'cached.mat'),['md5_' varargin{1}]);
		eval(strcat('retrieved_data=temp.md5_',varargin{1},';'))

		try
			temp = load(strcat(root,'cached_log.mat'),'retrieved_order');
			retrieved_order = temp.retrieved_order;
		catch
		end

		if ~exist('retrieved_order','var')
			retrieved_order{1} = varargin{1};
		else
			retrieved_order{end+1} = varargin{1};
			retrieved_order = unique(retrieved_order);
		end

		save(strcat(root,'cached_log.mat'),'retrieved_order');

		
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
		else
			% write it to this hash
			eval(strcat('md5_',varargin{1},'=varargin{2};'));
			save(strcat(root,'cached.mat'),'hash',strcat('md5_',varargin{1}),'-append')
		end
	end
end

% trim cache if needed
s = dir(strcat(root,'cached.mat'));
over_limit  = s.bytes/1e6 - maxCacheSize ;
if over_limit > 0
	warning('cache::cache is over the maximum allowed size!')
	% load the list of recently retrieved cache entries
	try
		temp = load(strcat(root,'cached_log.mat'),'retrieved_order');
		retrieved_order = temp.retrieved_order;

		% get the sizes of each variable in the cache
		m = matfile([root 'cached.mat']);
		temp = whos(m);
		hash = {};
		hash_size  = [];
		for i = 1:length(temp)
			hash{i} = strrep(temp(i).name,'md5_','');
		end
		hash = hash';
		hash_size = [temp.bytes]/1e6;

		% can we just get away with clearing variables that have never been retrieved?
		never_retrieved = setdiff(hash,[retrieved_order 'hash']);
		size_A = 0;
		for i = 1:length(never_retrieved)
			size_A = size_A + hash_size(find(strcmp(never_retrieved{i},hash)));
			if size_A > over_limit
				break
			end
		end
		% remove the ones that were never retrieved
		remove_these = never_retrieved(1:i);
		hash = setdiff(hash,remove_these);
		for i = 1:length(remove_these)
			remove_these{i} = ['md5_' remove_these{i}];
			eval([remove_these{i} '=[];'])
		end

		if size_A > over_limit
			% good, we can restrict ourselves to just deleting entries that were never retrieved
			
		else
			% we have to remove some things that were retrieved before. 
			for i = 1:length(retrieved_order)
				size_A = size_A + hash_size(find(strcmp(retrieved_order{i},hash)));
				if size_A > over_limit
					break
				end
			end
			remove_these = retrieved_order(1:i);
			hash = setdiff(hash,remove_these);
			for i = 1:length(remove_these)
				remove_these{i} = ['md5_' remove_these{i}];
				eval([remove_these{i} '=[];'])
			end
		end

		disp('cache::Pruning cache...this may take some time...')
		save([root 'cached.mat'],'md5*','hash','-append')

	catch
	 	% cache was never retrieved, so don't do anything. cache will temporarily go over, but can't be helped
	end
end
