% errorShade.m
% a fast error-shading plot function
% it's (really) fast because it doesn't use patch()
% it also creates only 2 plot objects, irrespective of the size of the data. 
% alternatives spawn as many patch objects as there are data points, making them useless for large
% datasets
% 
% usage:
% errorShade(x,y,y_error)
% 
% or if you want to plot on a particular axes, use
% errorShade(handle,x,y,y_error)
% 
% other options:
% errorShade(...,'SubSample',ss) % where ss is an integer. dices the data before plotting
% errorShade(...,'Color',[1 0 0]) % you need to specify a 3-element color, not 'r'
% errorShade(...,'LineWidth',2) 
% errorShade(...,'Shading',.4) % must be between 0 and 1
% 
% created by Srinivas Gorur-Shandilya at 10:48 , 04 June 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [line_handle, shade_handle] = errorShade(varargin)


if ~nargin
    help errorShade
    return
end

% parse inputs
if ishandle(varargin{1})
	h = varargin{1};
	varargin(1) = [];
else
	h = gca; % create a new axes if needed
end

hold(h,'on');


x = varargin{1};
x = x(:);
y = varargin{2};
y = y(:);
e = varargin{3};
e = e(:);

% defaults
Shading = .5;
Color = [1 0 0];
LineWidth = 1;
SubSample = 1;

varargin(1:3) = [];
if length(varargin)
	if iseven(length(varargin))
		for ii = 1:2:length(varargin)-1
	    	temp = varargin{ii};
	    	if ischar(temp)
	        	eval(strcat(temp,'=varargin{ii+1};'));
	    	end
		end
	else
	    error('Inputs need to be name value pairs')
	end
end

% subsample
SubSample = ceil(SubSample);
x = x(1:SubSample:end);
y = y(1:SubSample:end);
e = e(1:SubSample:end);


% first plot the error
ee = [y-e y+e NaN*e]';
xe = [x x NaN*(x)]';
ee = ee(:);
xe = xe(:);
shade_handle = plot(xe,ee,'Color',[Color + Shading*(1- Color)],'LineWidth',LineWidth);


% now plot the plot
line_handle = plot(x,y,'Color',Color,'LineWidth',3);
