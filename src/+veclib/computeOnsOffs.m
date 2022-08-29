
% 
% ### computeOnsOffs
%
% **Syntax**
%
% ```matlab
% [ons,offs]=computeOnsOffs(x)
% ```
%
% **Description**
%
% function finds rising and falling edges in a (assumed discrete)
% vector. If the vector is real valued, the rising and falling
% edges will be computed when vector is above/below median
%
% ons and offs are guaranteed to be the same length. For every 
% on, there will be a off after it. 


function [ons,offs] = computeOnsOffs(x)
if ~nargin
	help computeOnsOffs
	return
else
	x = x(:);
	x = double(x);
end

x= x/max(x);
x(x<.5) = 0;
x(x>0) = 1;

ons = find(diff(x)==1);
offs = find(diff(x)==-1);

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
	error('fatal: for unknown reasons, the length of offs and ons are not the same')
else
	% all OK
end
