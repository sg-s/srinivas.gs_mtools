% getDependencies.m
% [m,e] = getDependencies('foo.m')
% returns a list of dependencies for foo.m
% m is a cell array containing matlab dependencies
% and e is a cell array containing external dependencies.
% http://xkcd.com/754/
% 
% created by Srinivas Gorur-Shandilya at 10:19 , 06 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [m,e] = getDependencies(varargin)
if ~nargin 
	help getDependencies
	return
end

fname = varargin{1};
if ~ischar(fname)
	if isa(fname,'function_handle')
		fname = char(fname);
	else
		error('First argument should be a string or function handle')
	end
end

fname=which(fname);

fid = fopen(fname, 'rt'); 
lines = textscan(fid,'%[^\n]'); %reads line by line 
fclose(fid); 
lines = lines{1};

m = {};
e = {};
v = {}; % let's keep a list of the variables declared in the function we are looking at. 
seperators = {' ','(','{'};

for i = 1:length(lines)
	% find lines that are not comments or function definitions 
	if any(strfind(lines{i},'%')) || any(strfind(lines{i},'function'))
	else
		txt = lines{i};
		% is there an equals to sign? 
		if any(strfind(txt,'='))
			disp('equals to sign')
			keyboard
		else
			disp('no equals to sign')
			% look for seperators
			s = [];
			for i = 1:length(seperators)
				s = [s strfind(txt,seperators{i})];
			end
			if isempty(s)
				disp('No seperators')
				f = txt;
				if isbuiltin(f)
					m = add_to_list(m,f);
				else
					r = add_to_list(e,f);
				end
			else
				disp('at least one seperators')
				f = txt(1:s(1)-1);
				if isbuiltin(f)
					m = add_to_list(m,f);
				else
					r = add_to_list(e,f);
				end
			end
			
		end
	end

end


function bi = isbuiltin(f)
	bi = 0;
	if any(strfind(which(f),'built-in'))
		bi = 1;
	end

end

function l = add_to_list(l,f)
	if any(find(strcmp(l,f)))
	else
		l{end+1} = f;
	end
end

end

