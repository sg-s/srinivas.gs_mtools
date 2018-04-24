% readPref.m
% reads a preferences file, which is a human readable (and editable) text file and return formatted data
% 
% created by Srinivas Gorur-Shandilya at 4:37 , 16 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function pref = readPref(look_here)
pref = struct;

if ~nargin

	calling_func = dbstack;
	if ~isempty(calling_func)
		calling_func = calling_func(end).name;
		if any(strfind(calling_func,'/'))
			calling_func = calling_func(1:strfind(calling_func,'/')-1);
		end
		look_here = fileparts(which(calling_func));
	else
		look_here = pwd;
	end
else
	if isdir(look_here)
	else
		look_here = fileparts(look_here);
	end
end

% first load the default, then overwrite with pref
if exist([look_here filesep 'default.m'],'file') == 2
	line_content = lineRead([look_here filesep 'default.m']);
else
	error('No default preference file found!')
end

for i = 1:length(line_content)
	this_line = line_content{i};
	this_line(strfind(this_line,'%'):end) = [];
	if ~isempty(this_line)
		try 
			eval(['pref.' this_line ';'])
		catch err
			disp(err)
		end
	end
end

clear line_content


% see if there is a pref.m file in the folder we have to look in
if exist([look_here filesep 'pref.m'],'file') == 2
	line_content = lineRead([look_here filesep 'pref.m']);
else
	% maybe there is a default.m? 
	if exist([look_here filesep 'default.m'],'file') == 2
		copyfile([look_here filesep 'default.m'],[look_here filesep 'pref.m']);
		line_content = lineRead([look_here filesep 'default.m']);
	else
		error('No preference file found!')
	end
	
end

for i = 1:length(line_content)
	this_line = line_content{i};
	this_line(strfind(this_line,'%'):end) = [];
	if ~isempty(this_line)
		try 
			eval(['pref.' this_line ';'])
		catch err
			disp(err)
		end
	end
end

