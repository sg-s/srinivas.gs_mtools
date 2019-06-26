% like parula, but becomes red and high values intead
% of yellow

function C = redula(N)

if nargin == 0
	N = 100;
end


C = parula(N);

idx = floor(N*.8);


C(idx+1:end,2) = linspace(1,0,N-idx).*C(idx+1:end,2)';