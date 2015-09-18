% plotPieceWiseLinear.m
% creates a piecewise linear fit to the data, and then plots it
%
% created by Srinivas Gorur-Shandilya at 2:03 , 18 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function handles = plotPieceWiseLinear(a,b,varargin)


% defualts	
nbins = 10;
LineWidth = 2;
LineStyle = '-';
Marker = 'none';
Color = [0 0 0];

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

assert(isvector(a) & isvector(b),'Inputs must be vectors')
assert(length(a) == length(b),'Inputs should have equal lengths')

a = a(:);
b = b(:);

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
	ye(i) = sem(this_b);
end

if nbins < 20
    handles = errorbar(x,y,ye,'Color',Color,'LineWidth',LineWidth,'Marker',Marker,'LineStyle',LineStyle);
else
    [temp1, temp2] = errorShade(x,y,ye,'Color',Color,'LineWidth',LineWidth,'Marker',Marker,'LineStyle',LineStyle);
    handles.line = temp1;
    handles.shade = temp2;
end

