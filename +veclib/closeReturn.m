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

% validate and accept options
if mathlib.iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end


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