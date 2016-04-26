% lineRead.m
% reads a text file line by line and returns the text as a structure array
% usage:
% lines = lineRead(filename)
% 
% created by Srinivas Gorur-Shandilya at 4:30 , 18 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function lines = lineRead(filename)

fid = fopen(filename, 'rt'); 
lines = textscan(fid,'%[^\n]'); %reads line by line 
fclose(fid); 
lines = lines{1};