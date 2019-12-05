function D = ISI_parallel2(x, Y, FuncHandle)


N = size(Y,2);

D = zeros(N,1);

for i = 1:N
	D(i) = FuncHandle(x,Y(:,i));
end



