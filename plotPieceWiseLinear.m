% plotPieceWiseLinear.m
% creates a piecewise linear fit to the data, and then plots it
%
% created by Srinivas Gorur-Shandilya at 2:03 , 18 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [handles, data] = plotPieceWiseLinear(a,b,varargin)

handles = [];
data = [];

% defualts	
nbins = 10;
LineWidth = 2;
LineStyle = '-';
Marker = 'none';
trim_end = false;
make_plot = true;
Color = [0 0 0];
use_std = false;

if ~nargin
    help plotPieceWiseLinear
    return
else
    if iseven(nargin)
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

a = a(:);
b = b(:);

assert(length(a) == length(b),'Inputs should have equal lengths')

% remove NaNs
rm_this = isnan(a) | isnan(b);
a(rm_this) = [];
b(rm_this) = [];

[a,idx] = sort(a);
b = b(idx);

bin_edges = linspace(nanmin(a),nanmax(a),nbins+1);
x = NaN(nbins,1);
y = x; ye = y;

for i = 1:(nbins)
	this_a = a(a>bin_edges(i) & a < bin_edges(i+1));
	this_b = b(a>bin_edges(i) & a < bin_edges(i+1));
	x(i) = mean(this_a);
	y(i) = mean(this_b);
    if use_std
	    ye(i) = std(this_b);
    else
        ye(i) = sem(this_b);
    end
end

if trim_end
    x = x(2:end-1);
    y = y(2:end-1);
    ye = ye(2:end-1);
end

if make_plot
    if nbins < 20
        handles = errorbar(x,y,ye,'Color',Color,'LineWidth',LineWidth,'Marker',Marker,'LineStyle',LineStyle);
    else
        [temp1, temp2] = errorShade(x,y,ye,'Color',Color,'LineWidth',LineWidth,'Marker',Marker,'LineStyle',LineStyle);
        handles.line = temp1;
        handles.shade = temp2;
    end
end

% package data
data.x = x;
data.y = y;
data.ye = ye;
