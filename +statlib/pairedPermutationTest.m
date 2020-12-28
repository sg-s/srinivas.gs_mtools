
% given two vectors of the same length A and B
% that are paired measurements of something under 
% different conditions, this function performs a paired
% permutation test to test if the means of A and B are
% significantly different, and what the effect size is

function [p, handles] = pairedPermutationTest(A,B,N, MakePlot)


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


DM = nanmean(D);

if DM < 0
	p = mean(D_shuffled<DM);
else
	p = mean(D_shuffled>DM);
end


if ~MakePlot
	return
end


[K,XX] = ksdensity(D_shuffled,'BandWidth',[]);
K(XX>max(D_shuffled) | XX<min(D_shuffled)) = [];
XX(XX>max(D_shuffled) | XX<min(D_shuffled)) = [];

K = K/max(K);
K = K*nanmax([A; B])/10;

offset = nanmax([A; B])*.8;

[th, r] = cart2pol(XX, K);
[nx, ny] = pol2cart(th-pi/4, r);

handles.shape = plot(polyshape(offset+nx,offset+ny));


handles.shape.FaceColor = [.8 .8 .8];


% plot the line of the data
XX = [nanmin(A); nanmax(A)];
handles.line = plot(XX,XX-DM,'LineWidth',2);

