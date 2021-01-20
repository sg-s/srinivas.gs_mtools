% computes a kernel density estimate of data
% works for matrices too 

function K = kernelDensity(X, options)

arguments
	X double 
	options.Min = nanmin(X(:))
	options.Max = nanmax(X(:))
	options.NBins = 100
	options.LogBins = false
end


if options.LogBins
	if options.Min == 0
		error('Cannot use log bins with a lower limit of 0')
	end
	hx = logspace(log10(options.Min),log10(options.Max),options.NBins);
else
	hx = linspace(options.Min,options.Max,options.NBins);
end


N = size(X,1);
K = NaN(N,options.NBins);


for i = 1:N

	this = X(i,:);

	this(this>options.Max) = [];
	this(this<options.Min) = [];

	if all(isnan(this))
		continue
	end


	[D,XX] = ksdensity(this,'BandWidth',[]);
	D(XX>nanmax(this) | XX<nanmin(this)) = [];
	XX(XX>nanmax(this) | XX<nanmin(this)) = [];

	XX = [options.Min XX options.Max];
	D = [ 0 D 0];


	K(i,:) = interp1(XX,D,hx);

end

K = K/max(K(:));