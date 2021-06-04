% apply some function F to data Y based on 
% binning in X 
% similar to the built-in splitapply

function [R, BinCenters] = binapply(X,Y,F, options)

arguments
	X (:,1) double
	Y (:,1) double 
	F (1,1) function_handle
	options.BinSize (1,1) double =  (max(X)-min(X))/10
	options.SlideStep (1,1) double = (max(X)-min(X))/100
	options.BinStarts (:,1) double = NaN
end

if all(isnan(options.BinStarts))
	BinStarts = min(X):options.SlideStep:max(X);
else
	% use the user-provided binstarts
	BinStarts = options.BinStarts;
end
BinStops = BinStarts + options.BinSize;
R = BinStarts*NaN;

for i = 1:length(R)
	this = X >= BinStarts(i) & X <= BinStops(i);
	if sum(this) > 1
		R(i) = F(Y(this));
	end
end

BinCenters = BinStarts + options.SlideStep/2;