% listSubFunctions.m
% makes a list of all subfunctions in a matfile 
% 
% example usage:
% 
% listSubFunctions(name_of_m_file)
% 
% created by Srinivas Gorur-Shandilya at 9:50 , 15 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [L] = listSubFunctions(m)
L ={};
if ischar(m)
	if ~strcmp(m(end-1:end),'.m')
		m = [m '.m'];
	end
else
	error('input needs to be a string')
end

t = fileread(m);
if isempty(t)
	error('Could not find the file you asked for')
end

% split into different lines
t = regexp(t, '\n', 'split');

for i = 1:length(t)
	if ~isempty(strfind(t{i},'function'))
		% check for open braces -- these are the end point
		if isempty(strfind(t{i},'('))
			disp('no (')
			keyboard
		else
			z = strfind(t{i},'(') - 1;
		end

		% look for an equals to sign
		if isempty(strfind(t{i},'='))
			% disp('no =')
			% so just take everything after the function 
			a = strfind(t{i},'function') + 9;
		else
			a = strfind(t{i},'=') + 1;
		end
		this_line = t{i};
		this_line = strtrim(this_line(a:z));
		if ~isempty(this_line)
			L{end+1} = this_line;
		end
	end
end

L = L(:);
