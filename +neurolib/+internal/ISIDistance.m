% computes the distance between two sets of ISIs
% using my distance metric
function D = ISIDistance(A,B)

D = 0;

A = veclib.nonnans(A);
B = veclib.nonnans(B);

lA = length(A);
lB = length(B);

if lA == 0 && lB == 0
	return
end




if lA == 0
	D = length(B);
	return
end

if lB == 0
	D = length(A);
	return
end


for i = 1:lA
	[val, idx] = min(abs(A(i)-B));
	D = D + val/(A(i) + B(idx));
end

for i = 1:lB
	[val, idx] = min(abs(B(i)-A));
	D = D + val/(B(i) + A(idx));
end
