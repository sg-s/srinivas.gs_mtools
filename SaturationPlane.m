% SaturationPlane.m
% calculates the saturation plane from a 3-channel image. 
% created by Srinivas Gorur-Shandilya at 18:14 on 31-March-2014. Contact me at http://srinivas.gs/
% [s] = SaturationPlane(ff)
% 
% see http://en.wikipedia.org/wiki/HSL_and_HSV
function [s] = SaturationPlane(ff)
ff = double(ff);
s=(1-3*min(ff,[],3)./sum(ff,3));