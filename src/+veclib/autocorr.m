function acf = autocorr(X)
% similar to built-in autocorr function
% useful when you don't have all toolboxes

arguments
    X (:,1) double
end

% figure out size
n_lags = length(X)-1; % so that output is same size as input
nfft = 2^(nextpow2(length(X)) + 1);

% this is much faster than doing it discretely
F = fft(X, nfft);
F = F .* conj(F);
acf = ifft(F);
acf = real(acf(1:(n_lags+1))); 
   
acf = acf./acf(1); 

   