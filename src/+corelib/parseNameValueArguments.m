function options = parseNameValueArguments(options, varargin)

if nargin == 1
	return
end

% validate and accept options
if rem(length(varargin),2)==0
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
elseif  isstruct(varargin)
	% should be OK...
	options = varargin;
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end
