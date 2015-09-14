% bandPass.m 
% bandpasses input signal to spikes and/or slow fluctuations
% usage:
% [V, Vf] = bandPass(V,low_cutoff,high_cutoff)
% 
% used by spikesort and kontroller to filter extracellular recordings
%  
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [V, Vf] = bandPass(V,low_cutoff,high_cutoff)
if ~nargin
    help bandPass
    return
end
original_V = V;

% ignore NaNs in trace
if any(isnan(V))
	
	V(isnan(V)) = [];
end


Vf = V;
% high pass filter the trace to remove the LFP
if ~isinf(low_cutoff) && low_cutoff > 0
    if any(isnan(V))
        % filter ignoring NaNs
        Vf = V;
        Vf(~isnan(V)) = filtfilt(ones(1,low_cutoff)/low_cutoff,1,V(~isnan(V)));
    else
        Vf = filtfilt(ones(1,low_cutoff)/low_cutoff,1,V);
    end
    V = V - Vf;
end

% low pass filter the trace to remove high-frequency noise. 
if ~isinf(high_cutoff) && high_cutoff > 0
	V = filtfilt(ones(1,high_cutoff)/high_cutoff,1,V);
end

% reinsert this back into the original if there be NaNs
if any(isnan(original_V))
	original_V(~isnan(original_V)) = V;
	V = original_V;
	original_V(~isnan(original_V)) = Vf;
	Vf = original_V;
end

