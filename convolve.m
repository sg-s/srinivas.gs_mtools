% convolve.m
% convolve is just like filter.m, but accepts a-causal filters.
% usage: b = convolve(time,stimulus,K,filtertime)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function b = convolve(time,stimulus,K,filtertime)

if ~isvector(stimulus)
	error('stimulus not a vector');
else
	stimulus = stimulus(:);
end	

if ~isvector(K)
	error('Filter not a vector');
else
	K = K(:);
end	

if nargin < 4
	% just filter
	b = filter(K,1,stimulus-mean(stimulus));
	return
end	

if length(filtertime) ~= length(K)
	error('filtertime and filter dont have the same lengths')
end

dt = mean(diff(time));
fdt= mean(diff(filtertime));

if abs(fdt - dt)<eps
	% both are in the same units. all good.
	filtertime = round(filtertime/fdt);
	b = filter(K,1,stimulus-mean(stimulus));
	offset = abs(min(filtertime));
	b(1:offset) = [];
	b = [b; NaN(offset,1)];
elseif fdt == 1
	% assume that filtertime is given in vector indices, and it is not time.
	b = filter(K,1,stimulus-mean(stimulus));
	offset = abs(min(filtertime))-1; % this is the correct offset
	b(1:offset) = [];
	b = [b; NaN(offset,1)];
	filtertime = filtertime*dt;
else
	
	disp('need to re-sample K to match time units of stimulus')
	keyboard
end