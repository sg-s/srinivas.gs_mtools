%% animatePhasePlot
% makes a animated plot of Y vs X 
% example usage:
% x = cos(linspace(0,100,1e5));
% y = sin(linspace(0,100,1e5));
% animatePhasePlot(x,y)
% 
function [varargout] = animatePhasePlot(X,Y,varargin)

% get options from dependencies 
options = getOptionsFromDeps(mfilename);

% options and defaults
options.xlabel = '';
options.ylabel = '';
options.memory = 100;
options.sampling_rate = 1;
options.step_size = 10;
options.start_index = 200;

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

figure, hold on
set(gca,'XLim',[min(X) max(X)],'YLim',[min(Y) max(Y)])
axis square
xlabel(options.xlabel)
ylabel(options.ylabel)
h2 = plot(NaN*X,NaN*X,'LineWidth',2,'Color',[.7 .7 .7]);
h1 = plot(NaN(options.memory+1,1),NaN(options.memory+1,1),'LineWidth',4,'Color','r');
prettyFig
pause(1)
for i = options.start_index:round(options.step_size):length(X)
	x = X(i-options.memory:i);
	y = Y(i-options.memory:i);
	h1.XData = x;
	h1.YData = y;
	h2.XData(1:i) = X(1:i);
	h2.YData(1:i) = Y(1:i);
	title(['t = ' oval(i*options.sampling_rate) 's'])
	drawnow
end