% measures the distance between pairs of ISI sets
% 
function D = ISIDistance(X)

N = size(X,2);

D = NaN(N);



parfor i = 1:N
	D(:,i) = mtools.neuro.internal.ISI_parallel(X,i);
end


% N = round(logspace(1,3.5,20))
% T = NaN*N;

% figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
% h = plot(NaN,NaN,'ko');

% for i = 1:length(N)
% 	X = data(1).isis(:,1:N(i));
% 	tic; mtools.neuro.ISIDistance(X); T(i) = toc;
% 	h.XData = N;
% 	h.YData = T;
% 	drawnow
% end

% set(gca,'XScale','log','YScale','log')
% cf = fit(N(:),T(:),'poly3');
% plot(1:1e5,cf(1:1e5),'r')