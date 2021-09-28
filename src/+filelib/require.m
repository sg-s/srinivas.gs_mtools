function require()
%filelib.require copy data when needed
%
% function to copy over data from source to a destination
% as needed
%
% usage: 
% 
% filelib.require()
% 
% this reads out a file called data.json
% that has the following fields:
% data
% sources
% destination
%
% An example data.json looks like this:
% {
%     "data":
%     [
%         "2021-05-19-10-55-17",
%         "2021-05-11-12-55-16",
%     ],

%     "sources":
%     [
%     	"/path/to/some/local/folder",
%     	"dropbox"
%     ],

%     "destination": "/path/to/some/local/folder"
% }


allfiles = dir('*.json');
assert(~isempty(allfiles),'No JSON files found!')

args = jsondecode(fileread(allfiles(1).name));



for i = 1:length(args.sources)
	source = args.sources{i};


	if strcmp(source,'dropbox')
		filelib.downloadUsingDropboxCLI(args.data, args.destination)
	end


	allfiles = filelib.getAll(source);

	for j = 1:length(args.data)
		get_this = args.data{j};

		for k = 1:length(allfiles)

			if ~contains(allfiles(k),get_this)
				continue
			end

			[~,filename,ext]=fileparts(allfiles(k));


			to = fullfile(args.destination,strcat(filename,ext));

			if  exist(to,'file') == 2
				continue
			end

			

			disp(allfiles(k))

			copyfile(allfiles(k),to)

		end


	end

end