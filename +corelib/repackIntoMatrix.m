% rearranges a vector Z into a matrix based on X and Y vectors
%
function Z_repacked = repackIntoMatrix(X,Y,Z)

assert(isvector(X),'X must be a vector')	
assert(isvector(Y),'Y must be a vector')	
assert(isvector(Z),'Z must be a vector')	
assert(length(X) == length(Y),'All vectors must have equal lengths')
assert(length(X) == length(Z),'All vectors must have equal lengths')

assert(~any(isnan(X)),'X cannot contain NaNs')
assert(~any(isnan(Y)),'Y cannot contain NaNs')

YY = veclib.approxUnique(Y);
XX = veclib.approxUnique(X);

Z_repacked = NaN(length(XX),length(YY));

for i = 1:length(X)

	x = mathlib.aeq(XX,X(i));
	y = mathlib.aeq(YY,Y(i));
	Z_repacked(x,y) = Z(i);

end
