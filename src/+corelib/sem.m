function S = sem(X)


N = sqrt(sum(~isnan(X)));

S = nanstd(X)./N;