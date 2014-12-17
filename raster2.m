% raster2.m
% raster2(A,B)
% makes a raster plot of two different neurons. A (or B) can be either a logical matrix with 1 where a spike occurs, or long (zero padded) matrices of spike times. The time step is assumed to be 1e-4.
% This function is designed to be faster the the original raster
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.



function raster2(A,B,yoffset)

switch nargin 
case 0
    help raster2
    return
case 1
    B = [];
    yoffset = 0;
case 2
    yoffset = 0;
end

% plot A and B spikes
s = size(A);
if s(1) > s(2)
    A = A';
end
ntrials = size(A,1);
for i = 1:ntrials
    st = find(A(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(yoffset+i-1+zeros(1,length(st))); (yoffset+i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    plot(x*1e-4,y,'r')
end

s = size(B);
if s(1) > s(2)
    B = B';
end
ntrials = size(B,1);
for i = 1:ntrials
    st = find(B(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(yoffset+ntrials-1+i+zeros(1,length(st))); (yoffset+ntrials-1+i+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    plot(x*1e-4,y,'b')
end


