% ComputeOnsOffs.m
% given a logical vector x, this function returns the on and off times of the logical vector
% usage:
%  [ons,offs] = ComputeOnsOffs(x)
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [ons,offs] = ComputeOnsOffs(x)
if ~nargin
	help ComputeOnsOffs
	return
else
	x = x(:);
end

ons = diff(x);
offs = (ons<0);
ons(ons<0) = 0;
ons = find(ons);
offs = find(offs);

% check that the order is good
if isempty(ons)
    return
end
if isempty(offs)
    return
end
if ons(1) > offs(1)
    % the first pulse is lost. ignore it
    offs(1) = [];
end
ons = ons+1; % correct for derivative shift
if length(ons) > length(offs)
	offs = [offs; length(x)];
elseif length(offs) > length(ons)
	keyboard
else
	% all OK
end