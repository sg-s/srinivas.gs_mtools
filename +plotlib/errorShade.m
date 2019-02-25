% errorShade.m
% a fast error-shading plot function
% it's (really) fast because it doesn't use patch (for large datasets, see note below). 
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
% there is also a minimal usage of errorShade:
% errorShade(Y) % where Y is a matrix will automatically compute the SEM and use that as the error
%
% for small datasets and short vectors, errorShade falls back to shadedErrorBar (which uses patch objects, because it looks prettier). 
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


if nargin == 1 && width(varargin{1}) > 1
	y = varargin{1};
	x = 1:length(y); x = x(:);
	e = sem(y);
	y = mean2(y);
	varargin(1)= [];
else
	x = varargin{1};
	x = x(:);
	y = varargin{2};
	y = y(:);
	e = varargin{3};
	e = e(:);
	varargin(1:3) = [];
end

% defensive programming
if isempty(x)
	x = 1:length(y);
	x = x(:);
end
assert(length(x)==length(y),'All inputs must have the same length')
assert(length(x)==length(e),'All inputs must have the same length')

% defaults
Shading = .75;
Color = [1 0 0];
LineWidth = 1;
SubSample = 1;

if length(varargin)
	if mathlib.iseven(length(varargin))
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

if length(x) < 1e3
	% fall back to shadedErrorBar
	axes(h);
	h = shadedErrorBar(x,y,e,{'Color',Color,'LineWidth',LineWidth});
	line_handle = [h.mainLine h.edge(1) h.edge(2)];
	shade_handle = h.patch;
	set(line_handle,'LineWidth',LineWidth);
else
	% first plot the error
	ee = [y-e y+e NaN*e]';
	xe = [x x NaN*(x)]';
	ee = ee(:);
	xe = xe(:);
	shade_handle = plot(h,xe,ee,'Color',[Color + Shading*(1- Color)]);


	% now plot the plot
	line_handle = plot(h,x,y,'Color',Color,'LineWidth',LineWidth);
end

