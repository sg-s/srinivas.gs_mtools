% downloads files matching some patterns 
% using dropbox cli
% assuming you have it installed
% and configured 

function downloadUsingDropboxCLI(patterns, destination)

arguments
	patterns (:,1) string
	destination (1,1) string
end

corelib.addBrewPath;


% get all files in destination
allfiles = filelib.getAll(destination);

for i = 1:length(patterns)
	this = patterns(i);

	[~,output] = system(strcat("dbxcli search ", this));
	files = strsplit(output,'\t');

	for j = 1:length(files)
		file = files{j};
		[~,filename,ext] = fileparts(file);

		thisfile = strcat(filename,ext);

		if any(contains(allfiles,thisfile))
			continue
		end

		eval_str = strcat("dbxcli get " ,' "',file,'"'," ",destination);
	end

	
end