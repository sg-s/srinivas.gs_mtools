% Add a label to an axes. 
% 
% **Syntax**
%
% ```matlab
% label_handle = axlib.label(ax_handle,label)
% options = axlib.label()
% label_handle = axlib.label(ax_handle,label, options)
% ```
%
% **Description**
%
% Adds a label to an axes so you can generate publication-
% ready figures from within MATLAB. Includes options
% to futz with styles and placement so that you can make
% sure the label is where you want it to be. 
%
% See Also axlib.separate, axlib.equalize
%

 
function varargout = label(ax_handle,label,varargin)

% options and defaults
options.Capitalize = false;
options.XOffset = -.06;
options.YOffset = .01;
options.FontSize = 20;
options.FontWeight = 'bold';

if nargout && ~nargin 
	varargout{1} = options;
    return
end

options = corelib.parseNameValueArguments(options, varargin{:});


if options.Capitalize
	label = upper(label);
end

p = ax_handle.Position;
x = p(1) + options.XOffset - ax_handle.TightInset(1)/2;
y = p(2) + p(4) + options.YOffset + ax_handle.TightInset(4)/2;
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
label_handle.FontSize = options.FontSize;
label_handle.FontWeight = options.FontWeight;
label_handle.BackgroundColor = get(gcf,'Color');
label_handle.Tag = 'axes-label';
uistack(label_handle,'top')

if nargout == 1
	varargout{1} = label_handle;
end