

function hd = homedir()

hd = 'not set';
if ~ispc
	[~,hd] = system('echo $HOME');
end
hd = strtrim(hd);