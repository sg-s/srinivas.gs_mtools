% plots a raster of spikes
function raster(varargin)

% options and defaults
options.Color = lines;
options.LineWidth = 1;
options.yoffset = 0;
options.deltat = 1e-4;
options.fill_fraction = .95;
options.split_rows = true;

fn = fieldnames(options);

% extract spiketimes
last_var = length(varargin);
for i = 1:length(varargin)
	for j = 1:length(fn)
        if strcmp(fn{j},varargin{i}) | isstruct(varargin{i})
            last_var = i - 1;
            break
        end
    end
end


spiketimes = varargin(1:last_var);


varargin(1:last_var) = [];


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


if options.split_rows 
    new_spiketimes = {};
    for i = 1:length(spiketimes)
        if size(spiketimes{i},2) > size(spiketimes{i},1)
            spiketimes{i} = transpose(spiketimes{i});
        end
        for j = 1:size(spiketimes{i},2)
            if issparse(spiketimes{i}(:,j))
                new_spiketimes = [new_spiketimes; find(spiketimes{i}(:,j))];
            else
                new_spiketimes = [new_spiketimes; spiketimes{i}(:,j)];
            end
            
        end
    end
    options.split_rows = false;
    mtools.neuro.raster(new_spiketimes{:},options);
    return
    
end


% convert every raster into a simple list of spikes
for i = 1:length(spiketimes)
    if any(isnan(spiketimes{i}))
        % NaN padded
        spiketimes{i} = nonnans(spiketimes{i});
    elseif length(unique(spiketimes{1})) == 2
        disp('binary data')
        keyboard
    else
        % hope for the best and continue on
    end
end

for i = 1:length(spiketimes)


    st = (spiketimes{i});
    st = st(:)';
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(options.yoffset+i-1+zeros(1,length(st))); (options.yoffset+i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    y(y==max(y)) = min(y)+options.fill_fraction*(max(y)-min(y));


    plot(x*options.deltat,y,'Color',options.Color(i,:),'LineWidth',options.LineWidth), hold on


end



