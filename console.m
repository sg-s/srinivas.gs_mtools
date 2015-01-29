% console.m
% logs messages to console
% usage: console('message',1) logs "message" to a file called console.log and displays it on screen
% while 
% console('message') or console('message',0) merely logs to console without displaying anything
% 
% created by Srinivas Gorur-Shandilya at 1:45 , 17 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = console(m,v)
if ispc
	return
end

if nargin == 1
	v =0;
end

% figure out which function is calling it
calling_func = dbstack;

if ~isempty(calling_func)
	calling_func = {calling_func.name};
	calling_func(find(strcmp('console',calling_func))) = [];
	calling_func= calling_func{end};
end

if isempty(calling_func)
	return
end

if ~isempty(strfind(calling_func,'/'))
	calling_func = calling_func(1:strfind(calling_func,'/')-1);
end

a=which(calling_func);
a = fileparts(a);
filename = strcat(a,'/console.log');

unix(strcat('echo "',datestr(now),'-',calling_func,'-',m,'">>',filename));

if v
	disp(m)
end