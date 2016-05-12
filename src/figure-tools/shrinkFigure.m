% shrinkFigure.m
% shrinks MATLAB figures by downsampling, omitting, and re-plotting data
% use this to make figures that are visually identical, but much smaller
% DO NOT use this on figures that you treat as data -- this is meant purely for optimisation 
% for printing and export. 

function [varargout] = shrinkFigure(varargin)

% get options from dependencies 
options = getOptionsFromDeps(mfilename);

% options and defaults
options.crop_to_viewport = true;
options.dots_per_pixel = 1;

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


% get handle to all plots in current figure
axesHandles = findall(gcf,'type','axes');

% get the dimensions of the figure
cf = gcf;
assert(strcmp(cf.Units,'pixels'),'Figure Position should be in pixels')
fig_width = cf.Position(3);
fig_height = cf.Position(4);

for i = 1:length(axesHandles)
	% get the x and y limits
	xlim = axesHandles(i).XLim;
	ylim = axesHandles(i).YLim;

	% get the data
	c = get(axesHandles(i),'Children');
	for j = 1:length(c)
		if strcmp(get(c(j),'Type'),'line') || strcmp(get(c(j),'Type'),'scatter')
			x = get(c(j),'XData');
			y = get(c(j),'YData');

			warning off
			% crop to the viewport 
			if options.crop_to_viewport
				rm_this = x < xlim(1) | x > xlim(2) | y < ylim(1) | y > ylim(2);
				x(rm_this) = [];
				y(rm_this) = [];
				
				c(j).XData = x;
				c(j).YData = y;
				try
					c(j).CData(rm_this,:) = [];
				catch
				end
			end
			
			x = get(c(j),'XData');
			y = get(c(j),'YData');

			% subsample only if its very big, and if it's on a linear scale
			if length(x) > 1e3 && strcmp(c(j).Parent.XScale,'linear') && strcmp(c(j).Parent.YScale,'linear')

				% find the axes limits and size
				assert(strcmp(c(j).Parent.Units,'normalized'),'Expected axes units to be "normalized"')
				x_range = abs(diff(c(j).Parent.XLim));
				y_range = abs(diff(c(j).Parent.YLim));
				x_size = (c(j).Parent.Position(3));
				y_size = (c(j).Parent.Position(4));

				% convert x and y data into physical units
				raw_x = x; raw_y = y;
				x = (x./x_range)*x_size*fig_width;
				y = (y./y_range)*y_size*fig_height;


				% sub-sample data based on desired dots/pixel. to do this, we iteratively build the timeseries, accepting points only if they are sufficiently far away in real space
				xx = NaN*x; yy = NaN*y; this_pt_index = 1;
				xx(1) = x(1); yy(1) = y(1);
				disp('Subsampling data....')
				fprintf('\n')
				while this_pt_index < length(x)

					this_pt = [x(this_pt_index) y(this_pt_index)];

					% find distances in real space to all future data points
					d = sqrt((x(this_pt_index+1:end) - this_pt(1)).^2 + (y(this_pt_index+1:end) - this_pt(2)).^2);

					next_pt = this_pt_index + find(d>1/options.dots_per_pixel,1,'first');
					xx(next_pt) = raw_x(next_pt);
					yy(next_pt) = raw_y(next_pt);
					this_pt_index = next_pt;
					textbar(this_pt_index,length(x))
				end
				try
					% also shrink the CData
					c(j).CData(isnan(xx),:) = [];
				catch
				end

				xx = nonnans(xx);
				yy = nonnans(yy);

				set(c(j),'XData',xx);
				set(c(j),'YData',yy);
				warning on
			end % end check for size of data
		else
			% not a line or a scatter
			
		end 
	end
end