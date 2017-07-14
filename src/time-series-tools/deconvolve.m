% deconvolve.m
% given a filter K and a desired output T,
% find C such that K * C = T
% where * is the convolution operator
% 
% usage:
% C = deconvolve(K,T)
% where K and T are vectors
% 
% created by Srinivas Gorur-Shandilya at 11:07 , 27 July 2011. Contact me
% at http://srinivas.gs/contact/
% this was written a long while ago, and these usage notes have been added later:

function C = deconvolve(K,T)
if ~nargin
	help deconvolve
	return
end

K = K(:); T = T(:);
T = T - mean(T);
T = T/std(T);
K = K/norm(K);

% detemrine autocorrelation time of target
ta = autocorr(T,length(T)-1);
ta = find(ta < 0,1,'first');

%% deconvolve using Wiener Deconvolution--find best nsr using arbitrary thing I just made up
all_nsr =  logspace(-1,3,200);
r2 = NaN(length(all_nsr),1);
autocorr_time = NaN(length(all_nsr),1);

for i = 1:length(all_nsr)
    textbar(i,length(all_nsr))

    % deconvolve using the first half of the signal
    C = circshift(deconvwnr(T,K,all_nsr(i)),-floor(length(K)/2));

    % reproject
    Tp = filter(K,1,C);

    r2(i) = rsquare(Tp,T);
    temp = autocorr(C,length(C)-1);
    autocorr_time(i) = find(temp < 0,1,'first')/ta;

end
idx = find(r2 - autocorr_time > 0, 1, 'last');

C = circshift(deconvwnr(T,K,all_nsr(idx)),-floor(length(K)/2));
 