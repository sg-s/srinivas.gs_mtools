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

if ~strcmp(d(end).file,'make.m')
	disp('Not being published, skipping...')
	return
end

original_folder = pwd;

f = matlab.codetools.requiredFilesAndProducts(this_file);
git_hashes = {};
git_urls = {};
% check each dep for whether it lives within a git repo

for i = length(f):-1:1
	cd(fileparts(f{i}))
	[status, msg] = system('git rev-parse --show-toplevel');
	if status == 0
		repo_name{i} = strtrim(msg);
		[status,msg] = system('git rev-parse HEAD');
		if status == 0
			
			% also get the url
			[~,url]=system('git remote');
			url = strsplit(url);
			url = url{1};
			url= strtrim(url);
			[~,url] = system(['git remote get-url ' url]);
			git_urls{i} = strtrim(url);

			git_hashes{i} = msg(1:end-1);
		end
	end
end

rm_this = cellfun(@isempty,repo_name);
repo_name = repo_name(~rm_this);
git_hashes = git_hashes(~rm_this);
git_urls = git_urls(~rm_this);
[urepos, idx] = unique(repo_name);

for i = 1:length(urepos)
	[~,temp1,temp2] = fileparts(urepos{i});
	urepos{i} = [temp1 temp2];
end

for i = 1:length(idx)
	disp(['git clone ' git_urls{idx(i)} ])
	disp(['git checkout  ' git_hashes{idx(i)}])
end

% go back from whence you came
cd(original_folder)

