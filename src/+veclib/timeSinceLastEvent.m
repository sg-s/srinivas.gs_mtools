% for a given input binary vector,
% returns a vector of equal length with 
% times since the last event
% 
% usage: 
% time = veclib.timeSinceLastEvent(X);
% 
function time = timeSinceLastEvent(X)

arguments
	X (:,1) double
end


assert(length(unique(X)) <= 2, 'X should be a binary vector')


% if there are no events at all, abort 
if ~any(X)
	time = NaN*X;
	return
end

time = 1:length(X);
time = time(:);

E = find(X);


for i = 1:length(E)
	time(E(i):end) = time(E(i):end) - time(E(i));
end


time(1:E(1)) = NaN;
