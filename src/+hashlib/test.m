% tests the md5hash function

function test()

% check that we know where the compiled binary of md5hash is
a = which('hashlib.md5hash');
assert(~isempty(a),'md5hash not found on path, so cannot continue')
[folder_name, ~, ext] = fileparts(a);

assert(strcmpi(['.' mexext],ext),'md5hash does not point to compiled binary')

% make sure that all 3 compiled binaries are there -- useful for 
% testing on one platform and being sure it works on another
allfiles = dir(folder_name);

assert(any(strcmp({allfiles.name},'md5hash.mexa64')),'GNU/Linux binary missing')
assert(any(strcmp({allfiles.name},'md5hash.mexw64')),'Windows binary missing')
assert(any(strcmp({allfiles.name},'md5hash.mexmaci64')),'macOS binary missing')

assert(strcmpi(hashlib.md5hash(1),'e02e0d84c1f7b647c18ab9646d57ec89'),'md5hash returned an unexpected hash')
