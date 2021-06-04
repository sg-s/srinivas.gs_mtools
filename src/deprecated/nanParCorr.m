function varargout=nanParCorr(data,nlags,R)
% NANPARCORR partial autocorrelation function (ACF) with NaNs calculates
% the nlag autocorrelation coefficient for a data vector containing NaNs.
% Couples of data including NaNs are excluded from the computation. Here
% the PACF is calculated using the Pearson's correlation coefficient for
% each h-lag calculated between data(n)-Ê(data(n)|data(n-1)..data(n-h-1))
% and data(n-h)-Ê(data(n-h)|data(n-h-1)..data(n-1)), where Ê(x|x-1...x-n)
% is the best linear predictor of x accounting on the previous observations
% x-1...x-n.
%
% USAGE:
% nanautocorr(data,nlags) plot the PACF as a function of nlags.
% out=nanautocorr(data,nlags) returns a 1xnlags vector of linear
%   coefficients, caluclated on a 1xN or Nx1 data vector.
% [out,b]=nanparcorr(data,nlags,R) gives the confidence boundaries [b,-b]
% of the asymptotic normal distribution of the coefficient, using
% Bartlett's formula. R specifies the number of lags until the model is
% supposed to have a significant PAC coefficient, that is 95% of further
% lags coefficients should remain in the given confidence bounds in order
% to confirm the hypothesis that the signal is an effective R-lag AR
% process. R=[] is considered R=0 (the signal is supposed to be a white
% noise). If R is unspecified the boundary is not computed.
%
% 
%
% version: 0.1 2013/10
% author : Fabio Oriani.1, fabio.oriani@unine.ch
%    (.1 Chyn,University of Neuchâtel)

if isrow(data)
    data=data';
elseif sum(isnan(data))>sum(not(isnan(data)))/3
    warning('AC:toomanynans','more than a third of data is NaN! autocorrelation is not reliable')
end
out=zeros(nlags,1);
out(1)=1;
data=data-nanmean(data);
% use segnan to make several input for lpc
% without NaNs
for i=2:nlags+1
    nac=nanautocorr(data,i-2);
    l=ac2poly(nac);
    est=flipud(filter([0 -l(2:end)],1,flipud(data(1:end-i+1))));
    est2=filter([0 -l(2:end)],1,data(i:end));
    out(i)=corr(data(i:end)-est2,data(1:end-i+1)-est,'rows','complete');
end
if nargin==3
    if R>=nlags
        error('R must be minor than nlags')
    elseif isempty(R)
        R=0;
    end
% confidence bounds
b=1.96*numel(data)^-.5*sum(out(1:R+1).^2)^.5;
end
% plot
if nargout==0
    stem(0:nlags,out)
    title('sample PACF')
    grid on
    title('Sample PACF')
    xlabel('Lag'),ylabel('Sample Partial Autocorrelation')
    axis([0 nlags+1 min([out; -0.2]) 1])
    varargout=[];
    if nargin==3
    hline(1) = refline([0 b]);
    hline(2) = refline([0 -b]);
    set(hline,'Color','r')
    end
elseif nargout==2
    if nargin<3
        error('R has to be specified in order to have a confidence bound b')
    end
    varargout={out,b};
else
    varargout={out};
end