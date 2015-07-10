% summarise.m
% reads m files and makes a text file containing the file name and the second line of each m file. 
% usage:
% summarise -- creates a text file with a summary in markdown format of all the .m files in the folder
% summarise('github_username','doge') -- creates links to https://github/doge/
% 
% created by Srinivas Gorur-Shandilya at 1:28 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function  [] = summarise(varargin)

% defaults
github_user_name = 'sg-s';
repo_name = pwd;
temp = strfind(pwd,'/');
repo_name = repo_name(temp(end)+1:end);

if ~nargin
else
    if iseven(nargin)
    	for ii = 1:2:length(varargin)-1
        	temp = varargin{ii};
        	if ischar(temp)
            	eval(strcat(temp,'=varargin{ii+1};'));
        	end
    	end
	else
    	error('Inputs need to be name value pairs')
	end
end



allfiles = dir('*.m');

s = '';

for i = 1:length(allfiles)
	disp(allfiles(i).name)
	s = [s '### [' allfiles(i).name,'](https://github.com/' github_user_name '/' repo_name '/blob/master/' allfiles(i).name,')'];
	temp = fileread(allfiles(i).name);

	% find the '% characters'
	c = strfind(temp,'%');
	temp = temp(c(2):c(3));
	temp = strrep(temp,'%','');


	if strcmp(temp(1),' ')
		temp(1) = [];
	end
	s = sprintf([s,'\n',temp]);
end

if exist('summary.md')
	delete('summary.md')
end
f = fopen('summary.md','W');
fwrite(f,s,'char');
fclose(f);