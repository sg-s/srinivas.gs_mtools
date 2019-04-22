function X = staggerSpikes(S, varargin)


% everything in seconds
options.units = 1;
options.precision = 1e-3;
options.window_size = 10;
options.step_size = 1;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});

% check that things are duration objects

assert(isvector(S),'S should be a vector of spiketimes')
S = S(:);


% round spiketimes to required precision
S = round((S*options.units)/options.precision); % in precision units 
temp = sparse(max(S),1);
temp(S) = 1;
S = temp; clear temp;


% convert window_size and step_size into multiples of precision
window_size = round(options.window_size/options.precision);
step_size = round(options.step_size/options.precision);

X = veclib.stagger(S,window_size,step_size);

% find the max number of spikes in each row
N = max(full(sum(X)));

X2 = NaN(N,size(X,2));
for i = 1:size(X,2)
	temp = find(X(:,i));
	X2(1:length(temp),i) = temp;
end

% X2 is now in precision units
% convert back to normal units

X2 = X2*options.precision;

X = X2;