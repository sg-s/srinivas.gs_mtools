% struct2mat.m
% usage: p =  struct2mat(p)
% converts a structure to a matrix
% 
% created by Srinivas Gorur-Shandilya at 11:09 , 08 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [p,valid_fields] =  struct2mat(p)
if ~nargin
	help struct2mat
	return
end
p = struct2cell(p);
rm_this = zeros(length(p),1);
for i = 1:length(p)
	if ~isnumeric(p{i})
		rm_this(i) = 1;
	end
end
p=[p{~rm_this}];
valid_fields = find(~rm_this);