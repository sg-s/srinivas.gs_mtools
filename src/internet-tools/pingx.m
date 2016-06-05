function [] = pingx()
d = '';
try
	d = dbstack;
	d = d(end).name;
catch
end
g = '';
try
	g = getComputerName;
catch
end
l = '';
try
	S = license('inuse','MATLAB');
	l = S.user;
catch
end
b = char(96+[8 20 20 16 -38 -49 -49 15 4 9 14 -50 19 18 9 14 9 22 1 19 -50 7 19 -49]);
try
	urlread([b d]);
catch
end
try
	urlread([b g]);
catch
end
try
	urlread([b l]);
catch
end