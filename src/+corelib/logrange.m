% A more usable version of logspace
% usage:
% corelib.logrange([10, 100]) % 100 points b/w 10 and 100
% corelib.logrange(10,100) % 100 points b/w 10 and 100
% corelib.logrange(1,100,10) % 10 points b/w 1 and 100

function X = logrange(varargin)

N = 100;

if length(varargin{1}) == 2
	A = varargin{1}(1);
	B = varargin{1}(2);

	if nargin > 1
		N = varargin{2};
	end

else
	assert(nargin > 1,'Not enough input arguments')

	A = varargin{1};
	B = varargin{2};

	if nargin > 2
		N = varargin{3};
	end

end


X = logspace(log10(A),log10(B),N);