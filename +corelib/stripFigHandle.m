% strip an argument of a certain class from a list of arguments
% and return that if need be

function [fig, output_args] = stripFigHandle(varargin)


if strcmp(class(varargin{1}),'matlab.ui.Figure')
	fig = varargin{1};
	varargin(1) = [];
else
	fig = gca;
end

output_args = varargin;