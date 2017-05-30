% labels an axes with a label
% meant to be called by labelFigure, but can also be called directly
% usage:
% labelAxes(ax_handle,label)
% labelAxes is meant to label axes on the top left corner only. You can specify an offset in X or Y, but don't use these offset to place the label elsewhere. 
function [label_handle] = labelAxes(ax_handle,label,varargin)

% options and defaults
options.capitalise = false;
options.x_offset = -.06;
options.y_offset = .01;
options.font_size = 20;
options.font_weight = 'bold';

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


p = ax_handle.Position;
x = p(1) + options.x_offset - ax_handle.TightInset(1)/2;
y = p(2) + p(4) + options.y_offset + ax_handle.TightInset(4)/2;
label_handle = uicontrol('style','text');
label_handle.Units = 'normalized';

label_handle.Position(1) = x;
label_handle.Position(2) = y;
% trim the position -- they're always too wide
label_handle.Position(3) = label_handle.Position(3)/3;
v = version;
if str2double(v(1:3)) > 9.1
    label_handle.Position(4) = 2*label_handle.Position(4);
else
    label_handle.Position(4) = 1.3*label_handle.Position(4);
end

label_handle.String = label;
label_handle.FontSize = options.font_size;
label_handle.FontWeight = options.font_weight;
label_handle.BackgroundColor = get(gcf,'Color');
label_handle.Tag = 'axes-label';
uistack(label_handle,'top')

