% make a directory if needed
function mkdir(dirname)

if exist(dirname,'dir') ~=7 
	mkdir(dirname)
end