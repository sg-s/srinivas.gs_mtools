function Y = autocorr(X)
% similar to built-in autocorr function
% useful when you don't have all toolboxes

arguments
    X (:,:) double
end

N = size(X,2);

for i = N:-1:1

    this = zscore(X(:,i));

    % figure out size
    n_lags = length(this)-1; % so that output is same size as input
    nfft = 2^(nextpow2(length(this)) + 1);

    % this is much faster than doing it discretely
    F = fft(this, nfft);
    F = F .* conj(F);
    acf = ifft(F);
    acf = real(acf(1:(n_lags+1))); 
       
    Y(:,i) = acf./acf(1); 

end

