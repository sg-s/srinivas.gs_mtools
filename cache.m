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
function retrieved_data  = cache(varargin)

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
	load('cached.mat','hash') % only load the hashes, it's much faster
else
	hash = '';
	save('cached.mat','hash')
end


if nargin == 1
	console('retrieval mode')
	if isempty(find(strcmp(varargin{1}, hash)))
		retrieved_data = [];
		return
	else
		temp=load('cached.mat',strcat('md5_',varargin{1}));
		eval(strcat('retrieved_data=temp.md5_',varargin{1},';'))
	end
end

if nargin == 2
	console('write to hash table mode')
	if isempty(find(strcmp(varargin{1}, hash)))
		wh = length(hash)+1; % write here
		hash{wh}=varargin{1};
		eval(strcat('md5_',varargin{1},'=varargin{2};'));
		save('cached.mat','hash',strcat('md5_',hash{wh}),'-append')
	end
end

