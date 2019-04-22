% computes the close return plot of a vector X
% similar to a recurrance plot, but we plot
% relative times instead of absolute times 

function Y = closeReturn(X, varargin)

% options and defaults
options.max_delay = 2e3;
options.max_samples = 30;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});


X = X(:);


Y = NaN(length(X),options.max_samples);

D = options.max_delay;
S = options.max_samples;

parfor i = 1:length(X)

	if i + D > length(X)
		continue
	end

	ons = veclib.computeOnsOffs(X(i:i+D)>X(i));

	if length(ons) < 2
		continue
	end

	ons(1) = [];

	if length(ons) > S
		ons = ons(1:S);
		Y(i,:) = ons;
	else
		ons = [ons(:); NaN(S-length(ons),1)];
		Y(i,:) = ons;
	end


end