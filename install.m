% install.m
% install.m is a package manager for my MATLAB code
% usage:
% install [options] package_name 
% 
% list of options:
% -f 	force, ignore warnings
% -h 	help
% -u 	update install with the latest version (note: this does not update packages. to update packages, simply use install package_name)
% 
% list of packages available:
% 
% kontroller 				The Kontroller System (http://github.com/sg-s/kontroller/)
% srinivas.gs_mtools 		My general-purpose MATLAB toolbox (http://github.com/sg-s/srinivas.gs_mtools/)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = install(varargin)

% defaults
force = 0;
p = {};

% validate inputs
for i = 1:nargin
	if strfind(varargin{i},'-')
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

for i = 1:length(p)
	% check for this package on the path

end