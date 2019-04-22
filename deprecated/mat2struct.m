% mat2struct.m
% converts a vector into a structure
% this is the complement of struct2mat.m 
% usage: p = mat2strcut(x,field_names);
% you can get field_names using 
% fieldnames(p)
% or better yet,
% [x,field_names] = struct2mat(p);
% created by Srinivas Gorur-Shandilya at 12:54 , 08 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function p = mat2strcut(x,field_names)
switch nargin
	case 0
		help mat2strcut
		return
	case 1
		error('Need to specify fieldnames of the structure you want to create')
	case 2
		if length(x) == length(field_names)
		else
			error('Improper number of field names')
		end
end
for i = 1:length(x)
	eval(strcat('p.',field_names{i},'=x(',mat2str(i),');'))
end