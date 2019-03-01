% Find names of outputs of function
% returns a cell containing the names of the variables that are returned by a function, as defined in the function. 
% Usage:
% names=argoutnames('function_name')
% 
% names is a cell containing the names of the arguments as defined in the function
% Note that argoutnames won't work for most MATLAB functions as their code is obfuscated. 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function names = argOutNames(fname)
if ~nargin 
	help argoutnames
	return
end
fname = char(fname);

if nargout(fname) == 0
	names = '';
	return
end

names = cell(1,nargout(fname));

% first find out where it is 
funcfile=which(fname);

% read the file
fid = fopen(funcfile, 'rt'); 
lines = textscan(fid,'%[^\n]'); %reads line by line 
fclose(fid); 
lines = lines{1};


N_out = nargout(fname);

dots = strfind(fname,'.');
if ~isempty(dots)
	% this is not a simple function
	dots = dots(end);
	fname = fname(dots+1:end);
end

% find the line of the function definition 
func_def_line = [];
for i = 1:length(lines)
	if any(strfind(lines{i},'function')) && any(strfind(lines{i},fname))

		% check if this commented 
		if any(strfind(lines{i},'%'))  
			% maybe?
			if (strfind(lines{i},'%')) > strfind(lines{i},'function')
				func_def_line = i;
				break
			else
				
			end
		else
			% all good
			func_def_line = i;
			break
		end
	end
end
clear i

if isempty(func_def_line)
	disp('Error reading function. Can''t determine the function definiton line')
	keyboard
	

end

% find parentheses in this line
thisline = lines{func_def_line};
a = strfind(thisline,'[');
z = strfind(thisline,']');

if isempty(a) && isempty(z)
	a =  (strfind(thisline,'function')+8);
	z=  strfind(thisline,'=')-1;
end

if N_out == 1
	
	names{1} = thisline(a:z);
else
	% find commas
	c = strfind(thisline,',');
	c(c>z) = [];

	% grab the first
	aa = a+1;
	zz = c(1) -1;
	names{1} = thisline(aa:zz);

	% grab the middle ones
	for i = 2:N_out-1
		aa = c(i-1) + 1;
		zz = c(i) -1;
		names{i} = thisline(aa:zz);
	end

	% grab the end
	aa = c(end)+1;
	zz = z-1;
	names{end} = thisline(aa:zz);


	clear i
end

% remove brackets on single outputs
if length(names) == 1
	temp = strrep(names{1},'[','');
	temp = strrep(temp,']','');
	names{1} = temp;
end
