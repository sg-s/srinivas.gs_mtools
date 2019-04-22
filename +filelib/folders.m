% return list of folders in a given folder
function f = folders(p)

f = dir(p);

rm_this = false(length(f));

for i = 1:length(f)
	if strcmp(f(i).name(1),'.')
		rm_this(i) = true;
	end
	if ~f(i).isdir
		rm_this(i) = true;
	end
end

f(rm_this) = [];