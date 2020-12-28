
% given two vectors of the same length A and B
% that are paired measurements of something under 
% different conditions, this function performs a paired
% permutation test to test if the means of A and B are
% significantly different, and what the effect size is

function p = pairedPermutationTest(A,B,N, MakePlot)


arguments

	A (:,1) double
	B (:,1) double
	N (1,1) double = 10000
	MakePlot (1,1) logical = false
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
	D_shuffled(i) = nanmean(D_this);

end


D = nanmean(D);

if D < 0
	p = mean(D_shuffled<D);
else
	p = mean(D_shuffled>D);
end


if ~MakePlot
	return
end


[K,XX] = ksdensity(D_shuffled,'BandWidth',[]);
K(XX>max(D_shuffled) | XX<min(D_shuffled)) = [];
XX(XX>max(D_shuffled) | XX<min(D_shuffled)) = [];


h = area(XX,K);
h.FaceColor = [.8 .8 .8];
h.EdgeAlpha = 0;
h.FaceAlpha = .5


if D > 0

	if D < XX(end)
		K(XX<D) = [];
		XX(XX<D) = [];
		h = area(XX,K);
		h.LineWidth = 2;
		h.FaceAlpha = .5;
	else
		plot([D D],[0 max(K)],'LineWidth',2)
	end

else
	if D > XX(1)
		K(XX>D) = [];
		XX(XX>D) = [];
		h = area(XX,K);
		h.LineWidth = 2;
		h.FaceAlpha = .5;
	else
		plot([D D],[0 max(K)],'LineWidth',2)
	end


end

