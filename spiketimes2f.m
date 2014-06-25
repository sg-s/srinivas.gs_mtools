% spiketimes2f.m
% a function that converts a matrix of spiketimes to a firing rate vector,
% or matrix.
% created by Srinivas Gorur-Shandilya at 15:38 , 19 July 2011. Contact me
% at http://srinivas.gs/contact/
function [f] = spiketimes2f(spiketimes,time,GaussWin)
dt = mean(diff(time));

% figure out what spiketimes is
if length(unique(spiketimes)) == 2
	% it's probably binary data
	if isvector(spiketimes)
		keyboard
	else
		[a,b] = size(spiketimes);
		if b == length(time)
			spiketimes = spiketimes';
			b=a;
		end
		for i = 1:b
			temp=find(spiketimes(:,i));
			spiketimes(:,i) = 0;
			
			spiketimes(1:length(temp),i) = temp;
		end

	end
end

ntrials = b;
f = zeros(b,length(time));
for i = 1:ntrials
    % remove zeros
    thesespikes = min(time)+ dt*nonzeros(spiketimes(:,i));
    % add up the gaussians
    for j = 1:length(thesespikes)
        f(i,:) = f(i,:) + (normpdf(time,thesespikes(j),GaussWin));
         
    end
end
