% makes a rain cloud plot
function [S,P]=raincloud(X,varargin)

assert(isvector(X),'Expected data to be a vector')
X = X(:);

assert(isnumeric(X),'Expected data to be numeric')

options.YOffset = 0;
options.Height = 1;
options.Color = 'r';

options = corelib.parseNameValueArguments(options,varargin{:});

[D,XX] = ksdensity(X,'BandWidth',[]);
D(XX>max(X) | XX<min(X)) = [];
XX(XX>max(X) | XX<min(X)) = [];

XX = [min(X) XX max(X)];
D = [ 0 D 0];
D = D/max(D);
D = D*options.Height;
D = D + options.YOffset;



warning('off','MATLAB:polyshape:repairedBySimplify')
S = plot(polyshape(XX,D),'FaceColor',options.Color,'EdgeColor',options.Color,'FaceAlpha',.3);
warning('on','MATLAB:polyshape:repairedBySimplify')
Y = rand(length(X),1)*.5;
P = plot(X,options.YOffset-Y,'.','Color',options.Color);