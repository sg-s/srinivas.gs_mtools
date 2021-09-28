function addBrewPath()

p = getenv('PATH');
if ~contains(p,'/usr/local/bin')
	p = strcat(p,pathsep,'/usr/local/bin');
	setenv('PATH',p)
end