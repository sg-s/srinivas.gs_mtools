% raster2.m
% makes a raster plot of two different neurons. A (or B) can be either a logical matrix with 1 where a spike occurs, or long (zero padded) matrices of spike times. The time step is assumed to be 1e-4s
% This function is designed to be faster the the original raster
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.



function raster2(A,B,yoffset,colour)

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

fill_fraction = .95;
% plot A and B spikes
s = size(A);
if s(1) > s(2)
    A = A';
end
ntrials = size(A,1);

for i = 1:ntrials
    A(i,isnan(A(i,:))) = 0;
    st = find(A(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(yoffset+i-1+zeros(1,length(st))); (yoffset+i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    y(y==max(y)) = min(y)+fill_fraction*(max(y)-min(y));
 
    if nargin < 4
        plot(x*1e-4,y,'r'), hold on
    else
        plot(x*1e-4,y,'Color',colour), hold on
    end
end

s = size(B);
if s(1) > s(2)
    B = B';
end
ntrials = size(B,1);
for i = 1:ntrials
    B(i,isnan(B(i,:))) = 0;
    st = find(B(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(yoffset+ntrials-1+i+zeros(1,length(st))); (yoffset+ntrials-1+i+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    y(y==max(y)) = min(y)+fill_fraction*(max(y)-min(y));
    if nargin < 4
        plot(x*1e-4,y,'b'), hold on
    else
        plot(x*1e-4,y,'Color',colour), hold on
    end
end

if nargin > 1
    % fix ylabels to reflect the fact that we are plotting both A and B spikes
    yt = get(gca,'YTick');
    ytlabel = {};
    for i = 1:length(yt)
        if yt(i) > width(A)
            ytlabel{i} = oval(yt(i)-width(A));
        else
            ytlabel{i} = oval(yt(i));
        end
    end
    set(gca,'YTick',yt,'YTickLabel',ytlabel)
end


