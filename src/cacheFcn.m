% alternative to memoize, and better than it:
% - this is aware of changes to the function
% - caches are written to disk so persist 
%   across reboots 
%
% usage: [out1, out2...] = cacheFcn(@foo, in1, in2...)

function varargout = cacheFcn(fcn, varargin)


% find it

file_loc = which(func2str(fcn));

if isempty(file_loc)
	% probably anonymous function, hash the fcn directly
	fcn_hash = hashlib.md5hash(func2str(fcn));
else
	fcn_hash = hashlib.md5hash(file_loc,'file');
end


% hash the inputs 
input_hash = hashlib.hash(varargin);

% combine hashes
hash = hashlib.md5hash([input_hash fcn_hash]);

fname = strrep(strtrim(func2str(fcn)),'.','_');

first_hash = hashlib.hash(varargin{1});

cache_path = fullfile(filelib.cachePath('cache'),[fname '_' first_hash '.mat']);

if filelib.cacheOK(cache_path,hash)
	load(cache_path,'varargout')
else

	disp('Cache miss, this may take a while...')
	varargout = cell(1,nargout(fcn));
	[varargout{:}] = fcn(varargin{:});
	save(cache_path,'varargout','hash')
end

if ~iscell(varargout)
	varargout = {varargout};
end