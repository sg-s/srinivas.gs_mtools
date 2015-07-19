% TrialPlot.m
% created by Srinivas Gorur-Shandilya at 11:21 , 25 August 2011. Contact me
% at http://srinivas.gs/contact/
% rewritten 2012-3-14
% heavily rewritten on 2015-03-13
% 
% TrialPlot plots a matrix of values from many different trials, with many
% different ways of showing each trial, the first and second moments.
% 
% required arguments 
% 'data' -- a matrix of data to plot. the short dimension contains different trials, and the long dimension contains the time series/trial
%
% optional arguments
% 'color' -- which colour? 
% 'time' -- a time vector. if not specified, will default to matrix indices
% 'type' -- how do you want to show the data? options are 'sem','raw'
% 'normalize' -- 0 or 1. default is 0
% 'baseline' -- remove a baseline? specify time window to remove mean baseline
%  'limits' -- only plot data within the following limits. default is [-Inf Inf]
function  [mx, sx, notplotted] = TrialPlot(varargin)


if ~nargin
    help TrialPlot
    return
end

if iseven(nargin)
    for ii = 1:2:nargin-1
        temp = varargin{ii};
        if ischar(temp)
            eval(strcat(temp,'=varargin{ii+1};'));
        end
    end
    clear ii
else
    error('Inputs need to be name value pairs')
end

% fall back to defaults
if ~exist('data','var')
    error('Data not defined.')
end
if ~exist('time')
    time = 1:length(data);
end
if ~exist('normalize','var')
    normalize = 0;
end
if ~exist('color','var')
    color = 'b';
end
if ~exist('type','var')
    type = 'sem';
end
if ~exist('baseline','var')
    baseline = [NaN NaN];
end
if ~exist('limits','var')
    limits = [-Inf Inf];
end




mx = 0; sx = 0;
opacity = 0.5;
notplotted = [];
s = size(data);
dt = mean(diff(time));
%% orient correctly
if s(2) < s(1)
    data = data';
    s = size(data);
end

%% figure out colour
DoNotPlot = 0;
if ~strcmp(color,'cycle')
    cc = color;
    C = rgb(color);
    c =C; c(c==0) = opacity;

end


% common
badtraces = [];
for i = 1:s(1)
    if min(data(i,:)) < limits(1) || max(data(i,:)) > limits(2) || ~isempty(find(isnan(data(i,:)), 1))
        badtraces = [badtraces i];
    else
        if normalize
             data(i,:) = data(i,:)/max(data(i,:));
        end
        if any(isnan(baseline))
        else
            disp('remove baseline')
            keyboard
        end
    end

end        
data(badtraces,:) = [];
ss = size(data);

switch type
    case 'raw'
        if ~strcmp(color,'cycle')
            plot(time,data',cc)
        else
            plot(time,data')
        end
    case 'sem'
        if ss(1) > 1
            errorfill(time,mean(data),std(data)/sqrt(ss(1)),cc);
        elseif ss(1) == 1
            plot(time,data,cc)

        end
        
    
       
    otherwise
        disp('Unknown display format. Consult usage guide. ')
        help TrialPlot
end
