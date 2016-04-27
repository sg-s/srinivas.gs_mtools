% makes a coloured X-Y plot
% using scatter
% usage: 
% 
% colourXY(X,Y,C)
% where
% X, Y are vectors of the same length
% and C is a 3xN matrix storing colour info
% 
function [varargout] = colourXY(x,y,c,varargin)

% get options from dependencies 
options = getOptionsFromDeps(mfilename);

% options and defaults
options.foo = 1;
options.bar = 2;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

% validate and accept options
if iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options = setfield(options,temp,varargin{ii+1});
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end

scatter(x,y,12,c,'filled')

