%{
 created by G S Srinivas ( http://srinivas.gs ) @ 16:23 on Tuesday the
 22th of February, 2011
 usage: [f mx] = powerspec(Fs,x,v)
 where x is the input time series that you want to take the power spectral density of
 Fs is the sampling rate in Hz
 mx is the power
 f is the frequency
 v is an optional input that determines verbosity
%}
function  [f mx] = powerspec(Fs,x,v)

switch nargin 
	case 0
		help powerspec
		return
	case 1
		error('Not enough input arguments')

end	

if nargin < 3
    v = 1;
end


% Use next highest power of 2 greater than or equal to length(x) to calculate FFT.
nfft= 2^(nextpow2(length(x))); 
% Take fft, padding with zeros so that length(fftx) is equal to nfft 
fftx = fft(x,nfft); 
% Calculate the numberof unique points
NumUniquePts = ceil((nfft+1)/2); 
% FFT is symmetric, throw away second half 
fftx = fftx(1:NumUniquePts); 
% Take the magnitude of fft of x and scale the fft so that it is not a function of the length of x
mx = abs(fftx)/length(x); 

% Take the square of the magnitude of fft of x. 

mx = mx.^2; 

% Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% The DC component and Nyquist component, if it exists, are unique and should not be multiplied by 2.

if rem(nfft, 2) % odd nfft excludes Nyquist point
  mx(2:end) = mx(2:end)*2;
else
  mx(2:end -1) = mx(2:end -1)*2;
end


% This is an evenly spaced frequency vector with NumUniquePts points. 

f = (0:NumUniquePts-1)*Fs/nfft; 


% Generate the plot, title and labels. 

if v
    loglog(f,mx); 
    title('Power Spectrum'); 
    xlabel('Frequency (Hz)'); 
    ylabel('Power'); 
end

