% spikestimes2f.m
% this is a complete rewrite because earlier versions were very broken and seriously problematic 
% Usage: [f] =  spiketimes2f(spiketimes,time,dt,window,algo)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [f] =  spiketimes2f(spiketimes,time,dt,window,algo)

switch nargin 
case 0
	help spiketimes2f
case 1
	error('Need to define a time vector:')
	help spiketimes2f
case 2
	dt = 10*mean(diff(time));
	window = 30*dt;
	algo = 'gauss';
case 3
	window = 30*dt;
	algo = 'gauss';
case 4
	window = 30*dt;
end

% validate spiketimes 
if isvector(spiketimes)
	ntrials = 1;
	spiketimes = spiketimes(:);
	if length(unique(spiketimes)) == 2
		% this is binary data
		spiketimes = find(spiketimes);
	end
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
	ntrials = b;
end


switch algo

	case 'gauss'
		t=min(time):dt:max(time);
		f = zeros(length(t),ntrials);

		for i = 1:ntrials
			thesespikes = mean(diff(time))*nonzeros(spiketimes(:,i))+min(time);
			for j = 1:length(thesespikes)
	        	f(:,i) = f(:,i) + normpdf(t,thesespikes(j),window)';
	         
	    	end

		end
	case 'isi'
end