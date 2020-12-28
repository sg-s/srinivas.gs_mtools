
% given two vectors of the same length A and B
% that are paired measurements of something under 
% different conditions, this function performs a paired
% permutation test to test if the means of A and B are
% significantly different, and what the effect size is

function p = pairedPermutationTest(A,B,N, Display)


arguments

	A (:,1) double
	B (:,1) double
	N (1,1) double = 10000
	Display char = 'full'
end

assert(length(A) == length(B),'A and B should be of equal lengths')


% compute differences 
D = A - B;
D_shuffled = NaN(N,1);

M = length(A);

shuffle = rand(M,N) > .5;

for i = 1:N

	D_this = D;
	
	D_this(shuffle(:,i)) = -D_this(shuffle(:,i));
	D_shuffled(i) = mean(D_this);

end


D = mean(D);

if D < 0
	p = mean(D_shuffled<D);
else
	p = mean(D_shuffled>D);
end
