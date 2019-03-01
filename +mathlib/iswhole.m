% checks if a given array is a whole number

function L =  iswhole(X)

if abs((X-floor(X)))<eps
	L = true;
else
	L = false;
end
