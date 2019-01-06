% copies a function specified by a function handle
% onto a remote server over SSH
%
% usage:
% copyFun(func_handle, server_name)
%
% is func_handle is a simple function, that is copied over
% if func_handle is a class method, the entire class is copied over
% if func_handle is inside a package, the entire package is copier over
%
% if func_handle is a non-static method, an error is thrown

function copyFun(func_handle, server_name)

assert(isa(func_handle,'function_handle'),'Argument should be a function handle')
assert(nargin == 2,'Wrong number of input arguments')


fs = func2str(func_handle);
loc = which(fs);

assert(~isempty(loc),'Could not locate function')

if any(strfind(loc,'+'))
	% package

	p = strfind(loc,'+');
	p = p(1);
	z = strfind(loc,'/');
	z(z<p(1)) = [];
	z = z(1);
	package_name = loc(p+1:z-1);

	copy_this = loc(1:z);

	% is it in a class?
	if any(strfind(loc,'@'))
		% check that it's a static method
		p = strfind(loc,'@');
		p = p(1);
		z = strfind(loc,'/');
		z(z<p(1)) = [];
		z = z(1);
		class_name = loc(p+1:z-1);


		func_name = loc(z+1:end-2);

		% use undocumented feature to get info about static methods
		eval(['m = methods(' package_name '.' class_name ',' char(39) '-full'  char(39) ');']);
		
		this_func = lineFind(m,func_name);
		assert(~isempty(this_func),'Function not defined in class')

		assert(any(strfind(m{this_func},'Static')),'Function is not a static method of class')


	end

	[e,o]=system(['scp -r ' copy_this ' ' server_name]);
	assert(e == 0, 'Something went wrong when using SSH to copy files');




elseif any(strfind(loc,'@'))
	% class, but not in a package

	% check that it's a static method
	p = strfind(loc,'@');
	p = p(1);
	z = strfind(loc,'/');
	z(z<p(1)) = [];
	z = z(1);
	class_name = loc(p+1:z-1);

	copy_this = loc(1:z);

	func_name = loc(z+1:end-2);

	% use undocumented feature to get info about static methods
	eval(['[m,s] = methods(' class_name ');']);
	s = s(:,1);
	
	this_func = find(strcmp(m,func_name));
	assert(~isempty(this_func),'Function not defined in class')

	assert(strcmp(s{this_func},'Static'),'Function is not a static method of class')

	[e,o]=system(['scp -r ' copy_this ' ' server_name]);
	assert(e == 0, 'Something went wrong when using SSH to copy files');


else
	% assume simple function
	[e,o]=system(['scp -r ' loc ' ' server_name]);
	assert(e == 0, 'Something went wrong when using SSH to copy files');
	return
end
