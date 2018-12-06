% checks if a given variable is a whole number

function L =  iswhole(X)

if abs((X-floor(X)))<eps
	L = true;
else
	L = false;
end
