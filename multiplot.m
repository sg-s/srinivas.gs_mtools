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
function [] = multiplot(t,varargin)

% check if statistics toolbox exists
v = ver;
if ~any(strcmp('Statistics Toolbox', {v.Name}))
	error('You need to get the Statistics Toolbox to run multiplot')
end

% get number of inputs
nChannels = nargin - 1; 
n = length(varargin{1});

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
    plot(t,varargin{1})
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
	figure, hold all
	for i = 1:nChannels
		plot(t,x(:,i))
	end
	for i = 2:nargin
		inputnames{i-1} = inputname(i);
	end
	legend(inputnames)
else
	% plot each on a different subplot, and link plots
	figure, hold on
	nplots= length(unique(T));
	a = zeros(1,nplots);
	for i = 1:nplots
		a(i) = subplot(nplots,1,i); hold on; set(gca,'box','on')
		plotthese = find(T == i); 
		for j = plotthese
			plot(t,x(:,j));
		end
		inputnames = {};
		plotthese = plotthese + 1; 
		for j = 1:length(plotthese)
			inputnames{j} = inputname(plotthese(j));
		end
		legend(inputnames)
	end
	linkaxes(a,'x');
end



