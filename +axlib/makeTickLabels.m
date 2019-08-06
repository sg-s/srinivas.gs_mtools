% given a vector X, computes nice tick locations
% and formats ticklabels

function [L, loc] = makeTickLabels(X, skip)

assert(isvector(X),'X should be a vector')


loc = find(ismember(X,X(1:skip:end)));

L = {};
for i = length(loc):-1:1
	L{i} = strlib.oval(X(loc(i)));
end

