% smoothist.m
% smoothist (Smooth Histogram) accepts a list of scalar values and returns a smooth histogram, containing at least N bins, by repeatedly sampling from the data.
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [x,y] = smoothist(z,N)
switch nargin
case 0 
	help smoothist
	return
case 1
	if ~isvector(z)
		error('Inputs have to be vectors')
	elseif length(z) < 30
		error('Input should be at least 30 samples long')
	end
	N = 6;
case 2
	if ~isvector(z)
		error('Inputs have to be vectors')
	elseif length(z) < 30
		error('Input should be at least 30 samples long')
	end
otherwise
	error('Too many input arguments')
end

% determine the number of bins in the final output
N = max([floor(sqrt(length(z))) N]);
nrep = 100; % bootstrap this many times
frac = .5; % how much of the data should we sub-sample?
[y,x] = hist(z,N); y = y*0;
frac = floor(frac*length(z));

for i = 1:nrep
	new_sample = randperm(floor(length(z)));
	new_sample = new_sample(1:frac);
	y_this = hist(z(new_sample),N);
	y = y + y_this;
end

y = y/nrep;

