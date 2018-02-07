% phasify.m
% converts a time series into a 
% time series of amplitudes and phases 
% using Hilbert transforms and the analytic
% signal as in Pikovsky et al. 
%
% Srinivas Gorur-Shandilya
%
function [A, phi, H] = phasify(X)

assert(isvector(X),'Input must be a vector')
X = X(:);
X = X - mean(X);

H = hilbert(X);
A = sqrt(real(H).^2 + imag(H).^2);
phi = atan2(imag(H),real(H));
