% BatchTask.m
% reorganises a folder with many *.mat files into subfolders. the number of folders can be specified, or is automatically set to the number of physical cores on your CPU
% 
% created by Srinivas Gorur-Shandilya at 15:49 , 19 February 2014. Contact me at http://srinivas.gs/contact/
% splits up a task into as many folders as there are cores on the machine, or as you want.

function [] = BatchTask(n)

if nargin < 1
	n = feature('numCores');
	disp('Splitting task into as many cores as there are on this machine...')
end
allfiles = dir('*.mat'); % run on all *.mat files
% make sure they are real files
badfiles= [];
for i = 1:length(allfiles)
	if strcmp(allfiles(i).name(1),'.')
		badfiles = [badfiles i];
	end
end
allfiles(badfiles) = [];


batch_size = ceil(length(allfiles)/n);

for i = 1:n
	thisfolder=(strcat('batch_',mat2str(i)));
	mkdir(thisfolder)

	for j = 1:min([batch_size length(allfiles)])
		
		movefile(allfiles(j).name,strcat(thisfolder,filesep,allfiles(j).name))

	end
	% mark it as moved
	allfiles(1:batch_size) = [];

end

disp('All done.')

% save where this is 
temp=mfilename('fullpath');
s=strfind(temp,filesep);
temp = temp(1:s(end));
filename = strcat(temp,'batch_task.mat');
data_here = cd;
save(filename,'data_here')



