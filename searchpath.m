% searchpath.m
% usage:
% [inpath,containing_folder]= searchpath(name)
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [inpath,full_path]= searchpath(name)
if ~nargin
	help searchpath
	return
end

p = path;
c = pathsep;

if isempty(strfind(path,char(name)))
	inpath = 0;
	containing_folder = '';
else
	sep_points = strfind(p,c);
	full_path=p(sep_points(find(sep_points<strfind(path,char(name)),1,'last'))+1:sep_points(find(sep_points>strfind(path,char(name)),1,'first'))-1);
end