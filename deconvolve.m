% deconvolve.m
% Devonvolves a signal using Wiener deconvoltuion
% created by Srinivas Gorur-Shandilya at 11:07 , 27 July 2011. Contact me
% at http://srinivas.gs/contact/
function [x frec] = deconvolve(a,y)
%% parse inputs correctly
s = size(a);
if s(1)  > s(2)
    a = a';
end
% normalise inputs
y = normalise(y);
sy = size(y);
if sy(1) > sy(2)
    y = y';
end
%% deconvolve using Wiener Deconvolution--find best nsr

nsr = 100;
prederror= NaN(1,length(nsr));
memory = length(a) - 1;
for i = 1:length(nsr)

    x = deconvwnr(y,a);
    frec = zeros(1,length(y));
    x = [x((memory/2)+1:end) x(1:(memory/2))];
    for j = 1:length(y)-memory
        frec(j+memory)  = dot(a,x(j+memory:-1:j));
    end
    prederror(i) = dist(frec(1:length(y)-memory),y(memory+1:end)');
    
end


%% find minimum error
bestnsr = nsr(prederror == min(prederror));
x = deconvwnr(y,a,bestnsr);
x = [x((memory/2)+1:end) x(1:(memory/2))]; % weird correction -- possibly due to FFT?
x = normalise(x);



 