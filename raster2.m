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



function raster2(A,B)

switch nargin 
case 0
    help raster2
    return
case 1

    % plot only A spikes
    s = size(A);
    ntrials = s(1);
    for i = 1:ntrials
        st = A(i,:);
        st(st==0)=[];
        x = reshape([st;st;NaN(1,length(st))],1,[]);
        y = reshape([(i-1+zeros(1,length(st))); (i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
        plot(x*1e-4,y,'k')
    end
    set(gca,'YLim',[-1 ntrials+1])
    ylabel('Trial')
case 2
    % plot A and B spikes
    s = size(A);
    ntrials = s(1);
    for i = 1:ntrials
        st = A(i,:);
        st(st==0)=[];
        x = reshape([st;st;NaN(1,length(st))],1,[]);
        y = reshape([(i-1+zeros(1,length(st))); (i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
        plot(x,y,'b')
    end
    
    s = size(B);
    ntrials = s(1);
    for i = 1:ntrials
        st = B(i,:);
        st(st==0)=[];
        x = reshape([st;st;NaN(1,length(st))],1,[]);
        y = reshape([(ntrials+i+zeros(1,length(st))); (ntrials+i+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
        plot(x*1e-4,y,'r')
    end
    
    
    set(gca,'YLim',[-1 2*ntrials+1])
    
end
