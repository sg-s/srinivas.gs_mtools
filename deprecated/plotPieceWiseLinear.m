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

% defaults  
options.nbins = 10;
options.LineWidth = 2;
options.LineStyle = '-';
options.Marker = 'none';
options.trim_end = false;
options.make_plot = true;
options.Color = [0 0 0];
options.use_std = false;
options.proportional_bins = true;
options.show_error = true;
options.plot_here = [];


if nargout && ~nargin 
    varargout{1} = options;
    return
end

% first argument can be an axis handle
if isa(A,'matlab.graphics.axis.Axes')
    options.plot_here = A;
    A = B;
    B = varargin{1};
    varargin(1) = [];
end

% validate and accept options
if mathlib.iseven(length(varargin))
    for ii = 1:2:length(varargin)-1
    temp = varargin{ii};
    if ischar(temp)
        if ~any(find(strcmp(temp,fieldnames(options))))
            disp(['Unknown option: ' temp])
            disp('The allowed options are:')
            disp(fieldnames(options))
            error('UNKNOWN OPTION')
        else
            options.(temp) = varargin{ii+1};
        end
    end
end
elseif isstruct(varargin{1})
    % should be OK...
    options = varargin{1};
else
    error('Inputs need to be name value pairs')
end
assert(length(A) == length(B),'Inputs should have equal lengths')

% is it a matrix or a vector?
if isvector(A)
    if options.proportional_bins
        [x,y,xe,ye] = constructPWL(A,B,options);
    else
        [x,y,xe,ye] = constructPWL_equal_bins(A,B,options);
    end
else
    % it's a matrix. make sure it's oriented properly
    if size(A,1) < size(A,1)
        A = A';
    end
    if size(B,1) < size(B,1)
        B = B';
    end
    x = NaN(options.nbins,width(A));
    xe = x; y = x; ye = x;
    for i = 1:width(A)
        [x(:,i),y(:,i),xe(:,i),ye(:,i)] = constructPWL(A(:,i),B(:,i),options);
    end
    all_x = [min(min(x)) max(max(x))];
    all_x = all_x(1):(diff(all_x)/options.nbins):all_x(end);
    all_y = NaN(length(all_x),width(A));
    
    for i = 1:width(A)
        try
            all_y(:,i) = interp1(x(:,i),y(:,i),all_x);
        catch
            [~,ux] = unique(x(:,i));
            all_y(:,i) = interp1(x(ux,i),y(ux,i),all_x);
        end
    end
    rm_this = (width(A) - sum(isnan(all_y)') < round(width(A)/2));
    % re-sample


    all_x = all_x(~rm_this); all_x = [all_x(1) all_x(end)];
    all_x = all_x(1):(diff(all_x)/options.nbins):all_x(end);
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


if options.trim_end
    x = x(2:end-1);
    y = y(2:end-1);
    ye = ye(2:end-1);
end

if options.make_plot
    if isempty(options.plot_here)
        options.plot_here = gca;
    else
        if ~isvalid(options.plot_here)
            options.plot_here = gca;
        end
    end
    if options.show_error
        if options.nbins < 20
            handles = errorbar(options.plot_here,x,y,ye,'Color',options.Color,'LineWidth',options.LineWidth,'Marker',options.Marker,'LineStyle',options.LineStyle);
        else
            [temp1, temp2] = errorShade(options.plot_here,x,y,ye,'Color',options.Color,'LineWidth',options.LineWidth,'Marker',options.Marker,'LineStyle',options.LineStyle);
            handles.line = temp1;
            handles.shade = temp2;
        end
    else
        handles = plot(options.plot_here,x,y,'Color',options.Color,'LineWidth',options.LineWidth,'Marker',options.Marker,'LineStyle',options.LineStyle);
    end
end

% package data
data.x = x;
data.y = y;
data.ye = ye;
data.xe = xe;

    function [x,y,xe,ye] = constructPWL(a,b,options)
        % remove NaNs
        rm_this = isnan(a) | isnan(b);
        a(rm_this) = [];
        b(rm_this) = [];

        % label x axis by percentile
        l = labelByPercentile(a,options.nbins);

        x = NaN(options.nbins,1);
        y = x; ye = x; xe = x;

        for ci = 1:max(l)
            x(ci) = mean(a(l==ci));

            y(ci) = mean(b(l==ci));
            ye(ci) = sem(b(l==ci));
            if options.use_std
                xe(ci) = std(a(l==ci));
                ye(ci) = std(b(l==ci));
            else
                xe(ci) = sem(a(l==ci));
                ye(ci) = sem(b(l==ci));
            end
        end
    end

    function [x,y,xe,ye] = constructPWL_equal_bins(a,b,options)
        % remove NaNs
        rm_this = isnan(a) | isnan(b);
        a(rm_this) = [];
        b(rm_this) = [];

        % make equally spaced bins along the x-axis
        bin_edges = linspace(nanmin(A), nanmax(A),options.nbins+1);
        y = NaN(options.nbins,1);
        x = NaN(options.nbins,1);
        ye = y; xe = x;

        for ci = 1:length(x)
            this_b = (b(a > bin_edges(ci) & a < bin_edges(ci+1)));
            this_a = (a(a > bin_edges(ci) & a < bin_edges(ci+1)));
            rm_this = isnan(this_b) | isnan(this_a);
            this_a(rm_this) = []; this_b(rm_this) = [];
            if ~isempty(this_b)
                y(ci) = mean(this_b);
                x(ci) = mean(this_a);
                if options.use_std
                    ye(ci) = std(this_b);
                    xe(ci) = std(this_a);
                else
                    ye(ci) = std(this_b)/sqrt(length(this_b));
                    xe(ci) = std(this_a)/sqrt(length(this_a));
                end
            end
        end
        
    end

end