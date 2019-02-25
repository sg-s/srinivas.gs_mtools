% move.m
% moves the given plot up down, left or right
% usage:
% move(axis_handle,'up',0.1) % units are normalised 
% move(axis_handle,'right',0.1)
% 
% part of mtools, which lives here:
% https://github.com/sg-s/srinivas.gs_mtools

function move(plot_handle,direction,frac_dist)

if ~nargin	
	help move
	return
end

assert(strcmp(class(plot_handle),'matlab.graphics.axis.Axes'),'First argument should be a handle to axis')
assert(strcmp(class(direction),'char'),'Second argument should be a direction: up, down, left or right')
assert(any(strcmp(direction,{'up','down','left','right'})),'Second argument should be a direction: up, down, left or right')


if length(plot_handle) > 1
	for i = 1:length(plot_handle)
		plotlib.move(plot_handle(i),direction,frac_dist)
	end
	return
end

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