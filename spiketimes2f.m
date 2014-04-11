% spiketimes2f.m
% a function that converts a matrix of spiketimes to a firing rate vector,
% or matrix.
% created by Srinivas Gorur-Shandilya at 15:38 , 19 July 2011. Contact me
% at http://srinivas.gs/contact/
function [f] = spiketimes2f(spiketimes,time,win,sliding)
dt = mean(diff(time));
[ntrials ~] = size(spiketimes);
x = sliding:sliding:max(time);
f = zeros(ntrials,length(x));
s = win; % width of gaussian
for i = 1:ntrials
    % remove zeros
    thesespikes = dt*nonzeros(spiketimes(i,:));
    % add up the gaussians
    for j = 1:length(thesespikes)
        f(i,:) = f(i,:) + (normpdf(x,thesespikes(j),s));
         
    end
end
