% spinner.m
% simple, text-based spinner to indicate that some computation is being done
% drop spinner; into a for loop to spin
% 
% created by Srinivas Gorur-Shandilya at 4:19 , 02 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = spinner()
fprintf('\b')
r = randi(4);
if r == 1
	fprintf('\');
elseif r == 2
	fprintf('/');
elseif r == 3
	fprintf('-');
else
	fprintf('|');
end