function D = ISI_parallel2(x, Y, Variant)



N = size(Y,2);

D = zeros(N,1);

for i = 1:N
	D(i) = neurolib.internal.ISIDistance(x,Y(:,i),Variant);
end



