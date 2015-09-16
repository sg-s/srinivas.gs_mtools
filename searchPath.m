% searchPath.m
% searches path for a given folder
% usage:
% [inpath,full_path]= searchpath(name)
%
% inpath is 1 if name exists in your path, 0 o/w
% full_path is the full path to where name is installed
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [inpath,full_path]= searchPath(name)
if ~nargin
	help searchPath
	return
end

p = path;
c = pathsep;

if isempty(strfind(p,char(name)))
	inpath = 0;
	full_path = '';
else
	inpath = 1;
	sep_points = strfind(p,c);
	loc = strfind(p,char(name));
	rm_this = [];
	if length(loc) > 1
		rm_this = [];
		% there is more than location?
		for i = 1:length(loc)
			next_sep_point = sep_points(find(sep_points>loc(i),1,'first'));
			this_string = p(loc(i):next_sep_point);
			this_string = strrep(this_string,c,'');
			if ~strcmp(this_string,name)
				rm_this = [rm_this i];
			end
		end
	end
	loc(rm_this) = [];

	full_path=p(sep_points(find(sep_points<loc,1,'last'))+1:sep_points(find(sep_points>loc,1,'first'))-1);
	if isempty(full_path)
		full_path=p(1:sep_points(find(sep_points>loc,1,'first'))-1);
	end
end