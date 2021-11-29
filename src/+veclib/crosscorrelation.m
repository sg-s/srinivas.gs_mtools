% computes the cross correlation between two equally sized vectors
% uses normalization and averaging and 
% computes on staggered bins, taking care to zscore the data

function [C, C_shuffled, C_std, lags] = crosscorrelation(X,Y,args)

arguments
    X (:,1) double
    Y (:,1) double
    args.BinSize (1,1) double = 1e3 
    args.SlideStep (1,1) double = 100
end


XX = veclib.stagger(X,args.BinSize, args.SlideStep);
YY = veclib.stagger(Y,args.BinSize, args.SlideStep);



for i = size(XX,2):-1:1

    thisX = zscore(XX(:,i));
    thisY = zscore(YY(:,i));

    C(:,i) = xcorr(thisX,thisY,'normalized');

    a = randi(size(XX,2),1);
    b = randi(size(XX,2),1);

    C_shuffled = xcorr(zscore(XX(:,a)),zscore(YY(:,b)),'normalized');
end


C_std = std(C,[],2);
C = mean(C,2);
C_shuffled = mean(C_shuffled,2);

lags = 1:length(C);
lags = lags - length(C)/2;

if nargout == 0 
   
    figure, hold on
    plot(lags,C,'r')
    plot(lags,C_shuffled,'k')
end