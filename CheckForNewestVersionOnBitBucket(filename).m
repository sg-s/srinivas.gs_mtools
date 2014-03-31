% checks is a newer version is available on bitbucket
% created by Srinivas Gorur-Shandilya at 15:16 on 31-March-2014. Contact me at http://srinivas.gs/
% part of srinivas.gs_mtools
function [m] = CheckForNewestVersionOnBitBucket(filename)
fversion = '0.0.1'; 
h = urlread(strcat('https://bitbucket.org/srinivasgs/',filename,'/'));