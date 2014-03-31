% TrialPlot.m
% created by Srinivas Gorur-Shandilya at 11:21 , 25 August 2011. Contact me
% at http://srinivas.gs/contact/
% rewritten 2012-3-14
% 
% TrialPlot plots a matrix of values from many different trials, with many
% different ways of showing each trial, the first and second moments.
% 
% Usage: [] = TrialPlot(t,x,c,limits,normalisewindow,type)
% where t is a vector of times (fixed time step only)
% x                 is the data to be plotted (any 2D matrix)
% c                 is a color identifer. Permitted values: 'b','g','r','k'
% limits            is a two element vector containing minimum and maximum
%                   permissible, values allowed in plot (trials outside limits 
%                   will not be plotted, will not enter average)  e.g. [0 Inf] 
% normalisewindow   is a two element vector of matrix indicies over which to
%                   normalise. if [NaN NaN], no normalisation will occur.
% type              is a string determinging the type of plot
%                   allowed values are: 'data','std','sem'
%                   'data' plots every trial
%                   'std' plots mean and shades the standard deviation
%                   'sem' plots mean and shades standard error of mean
%                   'mean' plots only the mean. No errorbars plotted.
function  [mx sx notplotted] = TrialPlot(t,x,c,limits,normalisewindow,type)
mx = 0; sx = 0;
opacity = 0.5;
notplotted = [];
s = size(x);
T = t(end);
dt = mean(diff(t));
%% orient correctly
if s(2) < s(1)
    x = x';
    s = size(x);
end
%% figure out colour
DoNotPlot = 0;
if nargin > 2
    cc = c;
    C = rgb(c);
    c =C; c(c==0) = opacity;
    
else
    % choose default colour
    c = [opacity opacity 1];
end

%% figure out if there are limits, and if data needs to be screened
if nargin > 3
else
    limits = [-Inf Inf];
end
%% figure out if normalisation needs to happen
if nargin > 4
    if normalisewindow(1) == 0
        normalisewindow(1) = dt;
    end
else
    normalisewindow = [NaN NaN];
end
%% figure out the type of plot to be done
if nargin > 5
else
    type = 'data';
end
switch type
    case 'data'
        ymin = Inf; ymax = -Inf;
        oktraces = [];
        avgall = zeros(1,T/dt);
        co = 0;
        badtraces = [];
        for i = 1:s(1)
            
            if min(x(i,:)) < limits(1) || max(x(i,:)) > limits(2) ||  ~isempty(find(isnan(x(i,:)), 1)) 
                badtraces = [badtraces i];
            
            else
                if ~any(isnan(normalisewindow))
                    plotthis = x(i,:) - mean(x(i,normalisewindow(1)/dt:normalisewindow(2)/dt));
                
                else
                    plotthis = x(i,:);
                    
                end
                oktraces = [oktraces i];
                plot(t,plotthis,'Color',c,'LineWidth',2), hold on
                ymin = min(ymin,min(plotthis)); ymax = max(ymax,max(plotthis));
                avgall = avgall + plotthis; 
                co = co + 1;
            end
            

        end
        hold on
        if any(badtraces)
            
            disp('These traces were not plotted:')
            disp(badtraces)
        end
        notplotted = badtraces;
        
        plot(t,avgall/co,'Color',C,'LineWidth',4)
        box on, set(gca,'LineWidth',2,'FontSize',24), xlabel('Time (s)', 'FontSize',24)
        set(gca,'XLim',[min(t) max(t)],'YLim',[ymin ymax])
        mx = avgall/co;
    case 'std'
        badtraces = [];
        for i = 1:s(1)
            if min(x(i,:)) < limits(1) || max(x(i,:)) > limits(2)
                badtraces = [badtraces i];
            else
                x(i,:) = x(i,:) - mean(x(i,normalisewindow(1)/dt:normalisewindow(2)/dt));
            end

        end        
        x(badtraces,:) = [];
        disp('These traces were not plotted:')
        disp(badtraces)
        notplotted = badtraces;
        errorfill(t,mean(x),std(x),cc);
        box on, set(gca,'LineWidth',2,'FontSize',24), xlabel('Time (s)', 'FontSize',24)
        set(gca,'XLim',[0 T],'YLim',[min(mean(x))-min(std(x)) max(mean(x))+max(std(x))]);
        mx = mean(x);
        sx = std(x);
    case 'sem'
        badtraces = [];
        for i = 1:s(1)
            if min(x(i,:)) < limits(1) || max(x(i,:)) > limits(2) || ~isempty(find(isnan(x(i,:)), 1)) 
                badtraces = [badtraces i];
            else
                if ~any(isnan(normalisewindow)) % normalise on this window
                    x(i,:) = x(i,:) - mean(x(i,round(normalisewindow(1)/dt):round(normalisewindow(2)/dt)));
                end
            end

        end        
        x(badtraces,:) = [];
        ss = size(x);
        if ss(1) > 1
            if ~DoNotPlot
                try
                    errorfill(t,mean(x),std(x)/sqrt(ss(1)),cc);
                catch
                    errorfill(t,mean(x),std(x)/sqrt(ss(1)),'r');
                end
            end
        elseif ss(1) == 1
            if ~DoNotPlot
                plot(t,x,cc)
            end
        end
        if ~isempty(x)
            if s(1) == 1
                mx = x;
                sx = mx*0;
            else
                mx = mean(x);
                sx = std(x)/sqrt(ss(1));
            end
            
            %box on, set(gca,'LineWidth',2,'FontSize',24), xlabel('Time (s)', 'FontSize',24)
            set(gca,'XLim',[min(t)-0.5 max(t)+0.5],'YLim',[min(mean(x))-min(std(x))/sqrt(ss(1)) max(mean(x))+max(std(x))/sqrt(ss(1))])
        end
        if any(badtraces)
            disp('These traces were not plotted:')
            disp(badtraces)
        end
        notplotted = badtraces;
    case 'mean'
        badtraces = [];
        for i = 1:s(1)
            if min(x(i,:)) < limits(1) || max(x(i,:)) > limits(2) || ~isempty(find(isnan(x(i,:)), 1)) 
                badtraces = [badtraces i];
            else
                if ~any(isnan(normalisewindow)) % normalise on this window
                    x(i,:) = x(i,:) - mean(x(i,round(normalisewindow(1)/dt):round(normalisewindow(2)/dt)));
                end
            end

        end        
        x(badtraces,:) = [];
        ss = size(x);
        
            
        if ss(1) > 1
            errorfill(t,mean(x),0*std(x),cc);
        elseif ss(1) == 1
            
            plot(t,x,cc)
        end

        if ~isempty(x)
            if s(1) == 1
                mx = x;
                sx = mx*0;
            else
                mx = mean(x);
                sx = std(x)/sqrt(ss(1));
            end
            %box on, set(gca,'LineWidth',2,'FontSize',24), xlabel('Time (s)', 'FontSize',24)
            set(gca,'XLim',[min(t)-0.5 max(t)+0.5],'YLim',[min(mean(x))-min(std(x))/sqrt(ss(1)) max(mean(x))+max(std(x))/sqrt(ss(1))])
        end
        if any(badtraces)
            disp('These traces were not plotted:')
            disp(badtraces)
        end
        notplotted = badtraces;
       
    case 'sem-includeAll'
        % this case includes all traces, EXCEPT those that exceed limits in
        % the Normalise Window (which is not used to normalise)
        x(x<limits(1)) = NaN;
        x(x>limits(2)) = NaN;
        badtraces = [];
        if ~any(isnan(normalisewindow))
            % throw out traces that exceed limits in this window
            for i = 1:s(1)
                if any(isnan(x(i,normalisewindow(1):normalisewindow(2)))) 
                    badtraces = [badtraces i];
                end
            end
        end
        x(badtraces,:) = [];
        [mx stdx sx] = NaNAverage(x);
        errorfill(t,mx,sx,cc);
        box on, set(gca,'LineWidth',2,'FontSize',24) %xlabel('Time (s)', 'FontSize',24)
        set(gca,'XLim',[0 T],'YLim',[min(min(x)) max(max(x))] )
        disp('These traces were not plotted:')
        disp(badtraces)
        notplotted = badtraces;
    otherwise
        disp('Unknown display format. Consult usage guide. ')
        help TrialPlot
end
