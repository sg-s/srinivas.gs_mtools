% interleaves N vectors X1, X2, .. XN
% where
% all vectors have the same length (M)
% and returns a vector I that is M*N elements long
% where I(1) = X1(1)
% I(2) = X2(1)
% and so on

function I = interleave(varargin)

L = NaN(nargin,1);
for i = 1:nargin
	varargin{i} = varargin{i}(:);
	assert(isvector(varargin{i}),'Every argument has to be a vector')
	L(i) = length(varargin{i});

end

assert(max(L) == min(L),'All arguments should have the same length');
L = L(1);

I = NaN(L*nargin,1);

for i = 1:nargin
	I(i:nargin:end) = varargin{i};
end