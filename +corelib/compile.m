% helper function that compiles C++ code when needed
% 
% Usage:
% Say you have some .m file that needs to run some C++
% code. How do you know when to compile it?
% corelib.compile handles that for you.
% Simply drop
% 
% corelib.compile('/path/to/c++/file')
% in your m-file and it will be compiled when needed
%
% It is smart enough to know that if you change your C++ file
% you will have to re-compile

function compile(cpp_file_location)


[ParentDir, FuncName, ext] = fileparts(cpp_file_location);

assert(strcmp(ext,'.cpp'),'File does not have the extention ".cpp"');

% hash the C++ file
hash = hashlib.md5hash(cpp_file_location,'File');

if isempty(getpref('mexhashes'))
	% compile
	mex(cpp_file_location,'-output',[fileparts(cpp_file_location) filesep 'FuncName'])
	setpref('mexhashes',FuncName,hash)
else
	if isfield(getpref('mexhashes'),FuncName)
		old_hash = getpref('mexhashes',FuncName);
		if ~strcmp(old_hash,hash)
			% recompile
			mex(cpp_file_location,'-output',[fileparts(cpp_file_location) filesep FuncName])
			setpref('mexhashes',FuncName,hash)
		end
	else
		% recompile
		mex(cpp_file_location,'-output',[fileparts(cpp_file_location) filesep FuncName])
		setpref('mexhashes',FuncName,hash)
	end
end