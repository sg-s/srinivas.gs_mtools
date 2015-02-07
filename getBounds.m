% getBounds.m
% gets upper and lower bounds by reading a .m file
% specify bounds by structures lb.X  and ub.X
% 
% created by Srinivas Gorur-Shandilya at 10:08 , 07 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [lb, ub] = getBounds(fname)

p = getModelParameters(fname);
this_lb =[]; this_ub = [];
ub = struct; lb = struct;
% intelligently ask the model what the bounds for parameters are
mn= char(fname);
mn=which(mn);
txt=fileread(mn);
a = strfind(txt,'ub.');

for i = 1:length(a)
	this_snippet = txt(a(i):length(txt));
	semicolons = strfind(this_snippet,';');
	this_snippet = this_snippet(1:semicolons(1));
	eval(this_snippet)
end
a = strfind(txt,'lb.');
for i = 1:length(a)
	this_snippet = txt(a(i):length(txt));
	semicolons = strfind(this_snippet,';');
	this_snippet = this_snippet(1:semicolons(1));
	eval(this_snippet)
end

% lb_vec = -Inf*ones(length(fieldnames(p)),1);

