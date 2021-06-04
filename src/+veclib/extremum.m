% finds extremum of vector

function E = extremum(X)

arguments
	X (:,1) double
end

m = min(X);
M = max(X);

if abs(m) < M
	E =  M;
else
	E = m;
end