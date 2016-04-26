% install.m
% install.m is a package manager for @sg-s' MATLAB code. install.m downloads code from GitHub and fixes your MATLAB path so that everything works out of the box. 
% 
% usage:
% install [options] package_name 
% 
% list of options:
% -f 		force, ignore warnings, OVERWRITE old installations, update
% -h 		help
% 
% list of packages available:
% 
% kontroller 				The Kontroller System (http://github.com/sg-s/kontroller/)
% srinivas.gs_mtools 		My general-purpose MATLAB toolbox (http://github.com/sg-s/srinivas.gs_mtools/)
% spikesort 				Spikesorting for Kontroller  (http://github.com/sg-s/spikesort/)
% t-sne* 					t-distributed Stochastic Neighbour Embedding
% bhtsne* 					fast t-SNE implementation in C
% fitFilter2Data 			toolbox to fit linear filters to time series
% kontroller2 				experimental, event-driven version of kontroller
% fly-voyeur 				automated scoring of copulation behaviour in flies
% DeepLearnToolbox* 		toolbox for deep learning
% manipulate 				Mathematica-style function and model manipulation 
%
% [*] third party code
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = install(varargin)
if ~nargin
	help install
	return
end
% defaults
force = 0;
p = {};

return_here = pwd; 
warning off

% this allows install to translate the name of a package to a URL for a zipped executable
link_root = 'https://github.com/sg-s/';
link_cap = '/archive/master.zip';

% validate inputs
for i = 1:nargin
	if strfind(varargin{i},'-') == 1
		% it's an option
		if strmatch(varargin{i},'-h')
			help install
			return
		elseif strmatch(varargin{i},'-f')
			force = 1;
		else
			error('Unknown option')
		end
			
	else
		p{length(p)+1} = varargin(i);
	end
end


% figure out where to install this
if ispc
	code_path = winqueryreg('HKEY_CURRENT_USER',['Software\Microsoft\Windows\CurrentVersion\','Explorer\Shell Folders'],'Personal');
	code_path = strcat(code_path,'\code\');
else
	cd('~')
	code_path = cd;
	cd(return_here)
	code_path = strcat(code_path,'/code/');
end

% also make a temp folder to stash some files
if ispc
	temp_path = winqueryreg('HKEY_CURRENT_USER',['Software\Microsoft\Windows\CurrentVersion\','Explorer\Shell Folders'],'Personal');
	temp_path = strcat(temp_path,'\temp\');
else
	cd('~')
	temp_path = cd;
	cd(return_here)
	temp_path = strcat(temp_path,'/temp/');
end


% check for searchPath, or download if needed to temp path
if exist(temp_path,'dir') == 0
	mkdir(temp_path)
end
a = which('searchPath');
if isempty(a)
	urlwrite('https://raw.githubusercontent.com/sg-s/srinivas.gs_mtools/master/searchPath.m',[temp_path 'searchPath.m']);
end
addpath(temp_path)

for i = 1:length(p)
	disp(['Installing package: ' char(p{i})])
	install_this = 0;
	% check for this package on the path
	[s,install_path] = searchPath(char(p{i}));
	if s
		if ~force
			disp(strcat('WARNING:', char(p{i}),' is already installed. To update/overwrite the old installation, use "install -f [package_name]"'))
		else
			disp(strcat('Updating package:',char(p{i})))
			install_this = 1;
		end
	else
		install_this=1;
	end

	if isempty(install_path)
		if ispc
			install_path = [code_path char(p{i}) '\'];
		else
			install_path = [code_path char(p{i}) '/'];
		end
	end

	if install_this

		% wipe target clean, but ask for permission first
		if exist(install_path,'dir')
			rmdir(install_path,'s')
		end

		% download what you need to the temp folder
		disp('Downloading files...')
		try
			outfilename = websave(install_path,strcat(link_root,char(p{i}),link_cap));
		catch
			outfilename = urlwrite(strcat(link_root,char(p{i}),link_cap),[temp_path 'temp.zip']);
		end

	    % unzip to target
	    disp('Extracting files...')
	    unzip(outfilename,code_path)

	    % delete zip file
	    delete(outfilename)

	    % rename folder correctly to strip out the "master"
	    movefile([code_path char(p{i}) '-master'],install_path)

	    disp('Setting path...')
	    addpath(install_path)
	    savepath
		
	end

end

warning on

% delete temp folder
rmdir(temp_path,'s')



