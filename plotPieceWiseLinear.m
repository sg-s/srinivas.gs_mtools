% plotPieceWiseLinear.m
% creates a piecewise linear fit to the data, and then plots it
%
% created by Srinivas Gorur-Shandilya at 2:03 , 18 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [handles, data] = plotPieceWiseLinear(A,B,varargin)

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
normalise = false;

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

assert(length(A) == length(B),'Inputs should have equal lengths')

% is it a matrix or a vector?
if isvector(A)
    [x,y,xe,ye] = constructPWL(A,B,nbins);
else
    % it's a matrix. make sure it's oriented properly
    if size(A,1) < size(A,1)
        A = A';
    end
    if size(B,1) < size(B,1)
        B = B';
    end
    x = NaN(nbins,width(A));
    xe = x; y = x; ye = x;
    for i = 1:width(A)
        [x(:,i),y(:,i),xe(:,i),ye(:,i)] = constructPWL(A(:,i),B(:,i),nbins);
    end
    all_x = [min(min(x)) max(max(x))];
    all_x = all_x(1):(diff(all_x)/nbins):all_x(end);
    all_y = NaN(length(all_x),width(A));
    
    for i = 1:width(A)
        try
            all_y(:,i) = interp1(x(:,i),y(:,i),all_x);
        catch
        end
    end
    rm_this = (width(A) - sum(isnan(all_y)') < round(width(A)/2));
    % re-sample
    all_x = all_x(~rm_this); all_x = [all_x(1) all_x(end)];
    all_x = all_x(1):(diff(all_x)/nbins):all_x(end);
    all_y = NaN(length(all_x),width(A));
    
    for i = 1:width(A)
        try
            all_y(:,i) = interp1(x(:,i),y(:,i),all_x);
        catch
        end
    end

    y = nanmean(all_y');
    x = all_x;
    ye = sem(all_y');
    xe = 0*x;

end


if trim_end
    x = x(2:end-1);
    y = y(2:end-1);
    ye = ye(2:end-1);
end

if normalise
    ye = ye/max(y);
    y = y/max(y);
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
data.xe = xe;

    function [x,y,xe,ye] = constructPWL(a,b,nbins)
        % remove NaNs
        rm_this = isnan(a) | isnan(b);
        a(rm_this) = [];
        b(rm_this) = [];

        % label x axis by percentile
        l = labelByPercentile(a,nbins);

        x = NaN(nbins,1);
        y = x; ye = x; xe = x;

        for ci = 1:max(l)
            x(ci) = mean(a(l==ci));

            y(ci) = mean(b(l==ci));
            ye(ci) = sem(b(l==ci));
            if use_std
                xe(ci) = std(a(l==ci));
                ye(ci) = std(b(l==ci));
            else
                xe(ci) = sem(a(l==ci));
                ye(ci) = sem(b(l==ci));
            end
        end
    end

end
