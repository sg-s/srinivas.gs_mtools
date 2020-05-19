% formats a nice error message to display on assertion failure
% designed to be a drop-in replacement for assert
% where you have assert, use corelib.assert()

function assert(condition, varargin)

if nargin == 2
	txt = varargin{1};
elseif nargin == 3
	txt = varargin{2};
	msgID = varargin{1};
end

d = dbstack;


if length(d) > 1
	line2 = [ d(2).name ' >>>> ' txt ];
else
	line2 = [ txt  ];
end
line1 = repmat('-',1,length(line2)+3);

txt = [line1 newline newline line2 newline newline line1];


if nargin == 2
	assert(condition, txt)
elseif nargin == 3
	assert(condition, msgID, txt)
end
