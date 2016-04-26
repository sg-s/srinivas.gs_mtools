% fastFiltFilt.m
% fast, FFT-wrapper for filtfilt
% will only work for vector inputs (so only supports a small subset of filtfilt inputs)
% uses CONVNFFT
% this provides a 30X speedup on a filter 1e4 samples long, with a signal 6e4 samples long
% running on a GPU
% not that the result is not exactly the same as filtfilt everywhere (deviations at edges). Use with caution.
% 
% created by Srinivas Gorur-Shandilya at 10:29 , 09 February 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function y = fastFiltFilt(K,d,x)

x = x(:);
x3 = fastFilter(K,d,x);
x4 = flipud(fastFilter(K,d,flipud(x)));
y = mean([x3 x4],2);