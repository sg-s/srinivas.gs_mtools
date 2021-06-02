% for a given input binary vector,
% returns a vector of equal length with 
% times to the next non-zero value
% 
% usage: 
% time = veclib.timeToNextEvent(X);
% 
function time = timeToNextEvent(X)

arguments
	X (:,1) double
end


assert(length(unique(X)) <= 2, 'X should be a binary vector')


% if there are no events at all, abort 
if ~any(X)
	time = NaN*X;
	return
end

time = length(X):-1:1;
time = time(:);

E = find(X);


for i = length(E):-1:1
	time(1:E(i)) = time(1:E(i)) - time(E(i));
end


time(E(end)+1:end) = NaN;
