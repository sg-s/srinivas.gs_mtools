function D = ISIDistance(A,B)

D = 0;

A_z = find(isnan(A), 1,'first')-1;
B_z = find(isnan(B), 1,'first')-1;

if A_z == 0 && B_z == 0
	D = 0;
	return
end

if A_z == 0
	D = B_z;
	return
end

if B_z == 0
	D = A_z;
	return
end



for i = 1:A_z
	[val, idx] = min(abs(A(i)-B(1:B_z)));
	D = D + val/(A(i) + B(idx));
end

for i = 1:B_z
	[val, idx] = min(abs(B(i)-A(1:A_z)));
	D = D + val/(B(i) + A(idx));
end
