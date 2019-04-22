function [ax, output_args] = grabAxHandleFromArguments(varargin)

% grab axes handle, if they exist 

if strcmp(class(varargin{1}),'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

output_args = varargin;