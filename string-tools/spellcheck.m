% spellcheck.m
% small wrapper function to check spelling using aspell. will not work on Windows. 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
% uses aspell (http://aspell.net) to check spelling. needs aspell to work.
function [misspelt_words] = spellcheck(s)
[~,misspelt_words]=unix(strkat('echo "',s,'" | aspell --list'));