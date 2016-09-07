% install.m
% install.m is a dependency-free package manager for MATLAB code on Github. 
% install.m downloads code from GitHub and fixes your MATLAB path so that everything works out of the box. 
% 
% usage:
% install user/package_name
% 
% list of options:
% -f 		force, ignore warnings, OVERWRITE old installations, update
% -h 		help
% 
% (partial) list of packages available:
% 
% sg-s/kontroller 				The Kontroller System (http://github.com/sg-s/kontroller/)
% sg-s/srinivas.gs_mtools 		My general-purpose MATLAB toolbox (http://github.com/sg-s/srinivas.gs_mtools/)
% sg-s/spikesort 				Spikesorting for Kontroller  (http://github.com/sg-s/spikesort/)
% sg-s/t-sne* 					t-distributed Stochastic Neighbour Embedding
% sg-s/bhtsne* 					fast t-SNE implementation in C
% sg-s/fitFilter2Data 			toolbox to fit linear filters to time series
% sg-s/kontroller2 				experimental, event-driven version of kontroller
% sg-s/fly-voyeur 				automated scoring of copulation behaviour in flies
% sg-s/fitModel2Data				fits models to data
% sg-s/manipulate 				Mathematica-style function and model manipulation 
%
% zhmxu/mutual-information-ICA
% emukamel/CellSort
% kristinbranson/JAABA
% BellWilson2016/laserTrack2
% BellWilson2016/quickSort
% cortex-lab/sortingQuality
% cortex-lab/MATLAB-tools
% cortex-lab/KiloSort
% alanse7en/cluster_dp
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


% validate inputs
for i = 1:nargin
	if strfind(varargin{i},'-') == 1
		% it's an option
		if strmatch(varargin{i},'-h')
			help install
			return
		elseif strmatch(varargin{i},'-f')
			force = 1;
			varargin{i} = [];
		else
			error('Unknown option')
		end
			
	else
		p(length(p)+1) = varargin(i);
	end
end

% make sure all toolboxes specify the user and the toolbox name
for i = 1:length(p)
	assert(any(strfind(p{i},'/')),'Toolbox must specify user and toolbox name. For example, sg-s/spikesort')	
end

% this allows install to translate the name of a package to a URL for a zipped executable
link_root = 'https://github.com/';
link_cap = '/archive/master.zip';


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
	urlwrite('https://raw.githubusercontent.com/sg-s/srinivas.gs_mtools/dev/src/file-tools/searchPath.m',[temp_path 'searchPath.m']);
end
addpath(temp_path)

for i = 1:length(p)
	disp(['Installing package: ' char(p{i})])
	repo_name = p{i}(strfind(p{i},'/')+1:end);
	install_this = 0;
	% check for this package on the path
	[s,install_path] = searchPath(char(repo_name));
	if s
		if ~force
			disp(strcat('WARNING:', char(repo_name),' is already installed. To update/overwrite the old installation, use "install -f [package_name]"'))
		else
			disp(strcat('Updating package:',char(repo_name)))
			install_this = 1;
		end
	else
		install_this=1;
	end

	if isempty(install_path)
		if ispc
			install_path = [code_path char(repo_name) '\'];
		else
			install_path = [code_path char(repo_name) '/'];
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

	    movefile([code_path repo_name '-master'],install_path)

	    disp('Setting path...')
	    addpath(install_path)
	    savepath

	    % if there is a src folder inside this, add that too with all subfolders in it
	    if ispc
	    	if exist([install_path,'\src'])==7
	    		addpath(genpath([install_path,'\src']))
	    		savepath
	    	end
	    else
	    	if exist([install_path,'/src'])==7
	    		addpath(genpath([install_path,'/src']))
	    		savepath
	    	end
	    end

		
	end

end

% delete temp folder
rmdir(temp_path,'s')

warning on

