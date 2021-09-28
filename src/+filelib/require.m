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


allfiles = dir('*.json');
assert(~isempty(allfiles),'No JSON files found!')

args = jsondecode(fileread(allfiles(1).name));



for i = 1:length(args.sources)
	source = args.sources{i};


	if strcmp(source,'dropbox')
		keyboard
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