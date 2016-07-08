% condSpikeProb.m
% spiking probability, conditional on spike
% note that this is not the same as the ISI distribution
% 
% created by Srinivas Gorur-Shandilya at 11:05 , 31 July 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [p_spike,bin_centres] = condSpikeProb(A,B,T_max,dt)

if ~isvector(A) || ~isvector(B)
	error('needs a vector to work with')
end

if length(A) ~= length(B)
	error('A and B should have equal lengths')
end

T_max = floor(T_max/1e-4);
dt = floor(dt/1e-4);

A = A(:);
B = B(:);
spiketimesA = find(A);
spiketimesB = find(B);

% make the x axis
bin_left = 0:dt:T_max;
bin_right =bin_left + dt;
y = zeros(length(bin_left),1);

n = 0;
for i = 1:length(spiketimesA)
	spike_offsets = spiketimesB - spiketimesA(i);
	spike_offsets(spike_offsets<0) = [];
	spike_offsets(spike_offsets>T_max) = [];
	for j = 1:length(spike_offsets)
		y(find(spike_offsets(j)>bin_left,1,'last')) = y(find(spike_offsets(j)>bin_left,1,'last')) + 1;
	end
	n =  n+ length(spike_offsets);

end
p_spike = y/length(spiketimesA);
bin_centres = (bin_left + bin_right)/2;
bin_centres = bin_centres*1e-4;

% lose the last point
p_spike(end) = [];
bin_centres(end) = [];
