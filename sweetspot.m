% sweetspot.m
% makes a colour map that goes from blue (too low) through green (nice) to red (too high)
% 
% created by Srinivas Gorur-Shandilya at 4:16 , 12 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function map = sweetspot(n)

b = 1/n;
cs = [1:-.01:b];

% make the red ones
map = flipud([cs; zeros(1,length(cs)); zeros(1,length(cs))]');
map2 = ([zeros(1,length(cs)); zeros(1,length(cs)); cs]');
map = vertcat(map2,map);

map(:,2,:) = [fliplr(cs) cs];