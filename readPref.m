% readPref.m
% reads a preferences file, which is a human readable (and editable) text file and return formatted data
% 
% created by Srinivas Gorur-Shandilya at 4:37 , 16 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function pref = readPref(look_here)
if ~nargin
	pref = struct;
	calling_func = dbstack;
	if ~isempty(calling_func)
		calling_func = calling_func(end).name;
		[~,look_here]=searchPath(calling_func);
	else
		look_here = pwd;
	end
else
	if isdir(look_here)
	else
		look_here = fileparts(look_here);
	end
end

% see if there is a pref.m file in the folder we have to look in
if exist([look_here oss 'pref.m']) == 2
	lines = lineRead([look_here oss 'pref.m']);
else
	error('No preference file found!')
end

for i = 1:length(lines)
	this_line = lines{i};
	this_line(strfind(this_line,'%'):end) = [];
	if ~isempty(this_line)
		try eval(['pref.' this_line])
		catch err
			disp(err)
		end
	end
end




