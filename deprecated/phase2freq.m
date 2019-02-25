% phase2freq.m
% measures frequency of a phase vector
% works by measuring when the phase 
% vector "resets" and jumps by 2*pi
% so make sure phase isn't unwrapped
% this function returns :
% 1) T a Nx1 vector of time periods
% 2) loc, a Nx1 vector of locations of reset
%
% where N is the number of oscillations in phase
% usage:
% [T, loc] =  phase2freq(phase)

function [T, loc] = phase2freq(phi)

assert(isvector(phi),'phi should be a vector')
assert(nanmax(phi) - nanmin(phi) < 2.1*pi,'phase should be wrapped -- oscillations should be bounded by 2*pi')
temp = abs(diff(phi));
temp = temp/max(temp);
temp(temp<.5) = 0;
temp(temp>0) = 1;
loc = find(temp);
T = diff(loc);
loc(1) = [];