% strip an argument of a certain class from a list of arguments
% and return that if need be

function [ax, output_args] = stripAxesHandle(varargin)


if strcmp(class(varargin{1}),'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end

output_args = varargin;