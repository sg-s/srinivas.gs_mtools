function [L, loc] = makeLogTickLabels(X)

assert(isvector(X),'X should be a vector')


a = floor(log10(min(X)));
z = ceil(log10(max(X)));

if min(X) == 0
	a = floor(log10(min(nonzeros(X))));
end

loc = a:z;

L = {};
for i = length(loc):-1:1
	L{i} = ['10^{' strlib.oval(loc(i)) '}'];
end

