% multiplot.m
% mulitplot accepts 1 time axis and multiple data channels, and figures out what to do with them.
% If all the channels are of similar range, it plots them all one on top of each other
% If they are significantly different, it plots each channel on a different subplot and x-links all of them so that they can be zoomed and explored together
% this is meant primarily as a debugging/data exploration tool. 
% Ussage:
% 
% multiplot(time,x,y,z) 
% 
% or
% 
% multiplot([],x,y,z)
%
% created by Srinivas Gorur-Shandilya at 13:54 , 24 January 2014. Contact me at http://srinivas.gs/contact/
function [a] = multiplot(t,varargin)
a = [];
% check if statistics toolbox exists
v = ver;
if ~any(strcmp('Statistics Toolbox', {v.Name}))
	error('You need to get the Statistics Toolbox to run multiplot')
end


% color order for many plots on the same axes
c = {'r','g','b','k','m','r','g','b','k','m'};

% get number of inputs
nChannels = nargin - 1; 
n = length(varargin{1});

% make sure all vectors point the right way
if ~isempty(t)
	t = t(:);
end


% parse options
options.LineWidth = 2;
options.Color = 'k';
options.font_size = 24;
for i = 1:length(varargin)
	if isstruct(varargin{i})
		options = varargin{3};
		nChannels = nChannels - 1;
		varargin(i) = [];
	end
end
clear i


% create a figure if none exists
if isempty(findall(0,'Type','Figure'))
	figure, hold on
else
	% check if hold is on
	if ~ishold
		figure, hold on
	end
end

if nChannels > 1
	% check that all data channels have the same length
	for i = 2:nChannels
		m = length(varargin{i});
		if n ~= m
			error('All data must have the same length')
		end 
    end
else
    % only one channel, just plot it
    a = plot(t,varargin{1});
    return
end

% check that time has the same dimensions
if length(t) == 0
	% empty, generate own time
	t = 1:n;
elseif length(t) ~= n
	error('Time vector length and data length are not the same.')
end

% assemble all the data.
x = NaN(n,nChannels);
for i = 1:nChannels
	temp = varargin{i};
	% check that all data are vectors
	if isvector(temp)
		x(:,i) = temp(:);
	else
		error(strcat('All inputs should be vectors. The input "', inputname(i+1),'" is not.'))
	end
end

% figure out if to combine all or not
means = NaN(nChannels,1);
stds = NaN(nChannels,1);
for i = 1:nChannels
	means(i) = mean2(x(:,i));
	stds(i) = std2(x(:,i));
end
mins = means - stds;
maxs = means + stds;

T = clusterdata([mins maxs means stds],2);

combine = 1;
if any(min(maxs)<means)
	combine = 0;
end
if any(max(mins)>means) 
	combine = 0;
end
if combine == 0
	if length(unique(T)) > 1
	else
		T = 1:nChannels;
	end
	
end

if combine
	% just plot all on the same figure
	for i = 1:nChannels
		plot(t,x(:,i),'Color',c{i})
	end
	for i = 2:nargin
		inputnames{i-1} = inputname(i);
	end
	legend(inputnames)
else
	% plot each on a different subplot, and link plots
	
	nplots= length(unique(T));
	a = zeros(1,nplots);
	for i = 1:nplots
		a(i) = subplot(nplots,1,i); hold on; set(gca,'box','on')
		plotthese = find(T == i); 
		if length(plotthese) > 1
			plot(t,x(:,plotthese),'LineWidth',options.LineWidth);
		else
			plot(t,x(:,plotthese),'LineWidth',options.LineWidth,'Color',options.Color);
		end	
		
			
		
		inputnames = {};
		plotthese = plotthese + 1; 
		for j = 1:length(plotthese)
			inputnames{j} = inputname(plotthese(j));
		end
		legend(inputnames,'FontSize',options.font_size)
	end
	linkaxes(a,'x');
end

% xlabel
if t(1)~=1
	xlabel('Time (s)','FontSize',options.font_size)
end

