% computes the distance between two sets of ISIs
% using my distance metric
function D = ISIDistance(A,B)

D = 0;

A = veclib.nonnans(A);
B = veclib.nonnans(B);

A(A==0) = [];
B(B==0) = [];

lA = length(A);
lB = length(B);

% early exits
if lA == 0 && lB == 0
	% no ISIs in either set
	return
elseif  lA == 0
	% one set has only one spike
	D = 2;
	return
elseif lB == 0
	% one set has only one spike
	D = 2;
	return
end


DA = 0;
DB = 0;

for i = 1:lA
	[val, idx] = min(abs(A(i)-B));
	DA = DA + val/(A(i) + B(idx));
end

for i = 1:lB
	[val, idx] = min(abs(B(i)-A));
	DB = DB + val/(B(i) + A(idx));
end

D = DA/lA + DB/lB;