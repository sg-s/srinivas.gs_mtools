% return a unique ID 
% make a Unique ID every time this is run
% based on getComputerName, as well as the clock
% 
% 
% created by Srinivas Gorur-Shandilya at 2:51 , 08 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [u] = uid()
u = strcat(getComputerName, mat2str(round(abs(now-round(now))*1e14)));
