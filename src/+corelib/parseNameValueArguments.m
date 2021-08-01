function options = parseNameValueArguments(options, vargs)

% validate and accept options
if rem(length(vargs),2)==0
	for ii = 1:2:length(vargs)-1
	temp = vargs{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = vargs{ii+1};
    	end
    end
end
elseif isstruct(vargs{1})
	% should be OK...
	options = vargs{1};
else
	error('Inputs need to be name value pairs')
end
