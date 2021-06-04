% makes a dot-dash plot
% where means are indicated by dots and standard deviations
% by dashes

function dotDash(data, X)


M =  nanmean(data,2);
S = nanstd(data,[],2);



plot(1:length(M),M,'.','MarkerSize',10)
