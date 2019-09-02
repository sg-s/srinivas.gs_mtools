% like parula, but becomes red and high values intead
% of yellow

function C = redula(N)



if nargin == 0
	N = 100;
else
	assert(isnumeric(N) && isscalar(N) && isreal(N) ,'N must be a +ve integer');
	N = round(N);
end


C = parula(N);

idx = floor(N*.8);


C(idx+1:end,2) = linspace(1,0,N-idx).*C(idx+1:end,2)';