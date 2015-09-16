% searchPath.m
% searches path for a given folder
% usage:
% [inpath,containing_folder]= searchpath(name)
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
	if length(loc) > 1
		rm_this = [];
		% there is more than location?
		for i = 1:length(loc)
			
		end
	end

	full_path=p(sep_points(find(sep_points<strfind(p,char(name)),1,'last'))+1:sep_points(find(sep_points>strfind(p,char(name)),1,'first'))-1);
	if isempty(full_path)
		full_path=p(1:sep_points(find(sep_points>strfind(p,char(name)),1,'first'))-1);
	end
end