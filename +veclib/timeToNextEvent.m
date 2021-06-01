% for a given input binary vector,
% returns a vector of equal length with 
% times to the next non-zero value

function time = timeToNextEvent(X)

arguments
	X (:,1) double
end

assert(length(unique(X)) == 2, 'X should be a binary vector')

time = X*0;

time = length(X):-1:1;

E = find(X);

for i = length(E):-1:1
	time(1:E(i)) = time(1:E(i)) - time(E(i));
end

time(E(end)+1:end) = NaN;