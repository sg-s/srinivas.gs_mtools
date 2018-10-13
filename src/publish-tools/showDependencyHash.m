% showDependencyHash
% shows the repository name and git commit hash of all dependencies in a given m file 
% 
% created by Srinivas Gorur-Shandilya at 2:39 , 15 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = showDependencyHash(this_file)

assert(ischar(this_file),'input argument should be a string')
assert(exist(this_file,'file')==2,'file not found.')

d = dbstack;

if ~any(strcmp({d.name},'publish'))
	disp('Not being published, skipping...')
	return
end

original_folder = pwd;

[f,p]=matlab.codetools.requiredFilesAndProducts(this_file);
git_hashes = {};
% check each dep for whether it lives within a git repo

for i = length(f):-1:1
	cd(fileparts(f{i}))
	[s,m] = system('git rev-parse --show-toplevel');
	if s == 0
		repo_name{i} = strtrim(m);
		[status,m] = system('git rev-parse HEAD');
		if ~status
			git_hashes{i} = m(1:end-1);
		end
	end
end


[urepos, idx] = unique(repo_name);

for i = 1:length(urepos)
	[~,temp1,temp2] = fileparts(urepos{i});
	urepos{i} = [temp1 temp2];
end

for i = 1:length(idx)
	disp([urepos{i} ' (' git_hashes{idx(i)} ')'])
end

% go back from whence you came
cd(original_folder)

