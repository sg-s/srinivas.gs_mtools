% phasify.m
% converts a time series into a 
% a time-series of phases by filtering,
% and delay and embedding
% inputs: a time series (vector) X

function [theta, rho, metrics] = phasify(X,varargin)

assert(isvector(X),'Input must be a vector')
X = X(:);
X = X - mean(X);

theta = NaN*X;
rho = NaN*X;
metrics.T = NaN;
metrics.circ_dev = NaN;
metrics.mean_rho = NaN;
metrics.std_rho = NaN;

% options and defaults
options.period_fine_tune = [.9 1.1];
options.dt = 1; % ms
options.default_T = NaN;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
if iseven(length(varargin))
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



% FFT it to find the approximate period 
L = length(X);
NFFT = 2^nextpow2(L);
Fs = 1/(options.dt*1e-3); % Hz 

Y = fft(X,NFFT)/L;
f = Fs/2*[linspace(0,1,NFFT/2) linspace(1,0,NFFT/2)]; 

min_f = 1/(length(X)*options.dt*1e-3);

Y = abs(Y);
Y(f<2*min_f) = 0;

[~,idx] = max((Y));

T = 1e3*(1./f(idx));


if isinf(T)
	% can't estimate T, give up
	return
end

% fine tune the period it a bit 
all_delays = unique(round(linspace(options.period_fine_tune(1)*T,options.period_fine_tune(2)*T,100)));
r2 = NaN*all_delays;

for i = 1:length(all_delays)
	Y = circshift(X,all_delays(i));
	r2(i) = corr(X,Y);
end

[~,idx] = max(r2);

T = all_delays(idx);  % <--- this is probably the period of the signal

% if we shift it by a quarter of the period, then we get a circle
Y = circshift(X,floor(T/4));

if nargout == 0
	figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
	subplot(1,2,1); hold on

	plot(X(floor(T/2):end),Y(floor(T/2):end))
end

% convert into polar coods
[theta,rho] = cart2pol(X,Y);

% now compute the mean radius around the circle 
% and other metrics round the circle 
% we do so by binning the circle into 100 segments 
% and pooling data in those bins

% but first, snip off a bit from the front
X = X(floor(T/2):end);
Y = Y(floor(T/2):end);

phase_bins = linspace(-pi,pi,100);

std_rho = NaN(length(phase_bins)-1,1);
mean_rho = NaN(length(phase_bins)-1,1);

for i = 1:length(mean_rho)-1
	mean_rho(i) = mean(rho(theta > phase_bins(i) & theta < phase_bins(i+1)));
	std_rho(i) = std(rho(theta > phase_bins(i) & theta < phase_bins(i+1)));
end

circ_dev = nanstd(mean_rho)/nanmean(mean_rho); % deviation from a circle 


if nargout == 0

	subplot(1,2,2); 
	polarplot(theta,rho)

end


metrics.T = T;
metrics.circ_dev = circ_dev;
metrics.mean_rho = mean_rho;
metrics.std_rho = std_rho;