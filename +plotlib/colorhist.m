% plots a histogram that also serves as a colorbar
function p = colorhist(varargin)

ax = gca;

if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
end

X = varargin{1};
varargin(1) = [];
assert(isvector(X),'Expected data to be a vector')
X = X(:);
assert(isnumeric(X),'Expected data to be numeric')

assert(length(varargin)>0,'Not enough input arguments')

options.BinLimits = [];
options.NumBins = 50;

options = corelib.parseNameValueArguments(options,varargin{:});

[hy,hx] = histcounts(X,'BinLimits',options.BinLimits,'NumBins',options.NumBins,'Normalization','pdf');


min_value = min(hy(hy>0));
hy = [0 hy 0];
hx = [hx hx(end)];
hy(hy==0) = min_value;

p = patch(ax,hx,hy,1:length(hx));
p.LineWidth = 1.5;