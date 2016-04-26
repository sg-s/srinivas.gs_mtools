% movePlot.m
% moves the given plot up down, left or right
% usage:
% movePlot('up',0.1)
% 
% created by Srinivas Gorur-Shandilya at 2:44 , 29 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = movePlot(plot_handle,direction,frac_dist)

if ~nargin	
	help movePlot
	return
end

assert(strcmp(class(plot_handle),'matlab.graphics.axis.Axes'),'First argument should be a handle to axis')
assert(strcmp(class(direction),'char'),'Second argument should be a direction: up, down, left or right')
assert(any(strcmp(direction,{'up','down','left','right'})),'Second argument should be a direction: up, down, left or right')

old_pos = plot_handle.Position;

switch direction
	case 'up'
		plot_handle.Position(2) = old_pos(2)+frac_dist;
	case 'down'
		plot_handle.Position(2) = old_pos(2)-frac_dist;
	case 'left'
		plot_handle.Position(1) = old_pos(1)-frac_dist;
	case 'right'
		plot_handle.Position(1) = old_pos(1)+frac_dist;
end