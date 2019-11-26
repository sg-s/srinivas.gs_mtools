% checks if the given folder is writeable
function TF = isWriteable(folder_name)

TF = false;

if nargin == 0
	folder_name = pwd;
end

warning('off','MATLAB:DELETE:Permission')
warning('off','MATLAB:DELETE:FileNotFound')

try
	delete([folder_name filesep 'test']');
catch
end


warning('on','MATLAB:DELETE:Permission')
warning('on','MATLAB:DELETE:FileNotFound')

try
	f = fopen([folder_name filesep 'filelib_is_writable.temp'],'w');
	l = fwrite(f,42);
	assert(l == 1,'Write failure');
	TF = true;
catch
	TF = false;
end
if f > 0
	fclose(f);
end


try
	delete([folder_name filesep 'test']);
catch
end
