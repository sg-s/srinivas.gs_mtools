% raster.m
% makes a raster plot of spikes
% the input can be any of the following:
% (a) a sparse matrix where 1 = spike
% (b) a zero or NaN-padded matrix
%
% raster allows your to send in as many 
% different spike trains as you want, with
% as many trials of each as you want. for
% example, raster is being called with 3 inputs:
% raster(A,B,C)
% where A, B and C can be either (a) or (b)

function raster(A,varargin)

assert(ismatrix(A),'expected first argument to be a matrix')

% in any of the varargin are the same size as A, 
% remove them (we will treat them as additional
% matrices to plot)

A = {A};

if length(varargin) > 0
    goon = false;
    if length(varargin{1}) == length(A{1})
        goon = true;
    end
    while goon
        if length(varargin{1}) == length(A{1})
            A{length(A)+1} = varargin{1};
            varargin(1) = [];
        else
            goon = false;
        end
    end
end

% options and defaults
options.Color = [1 0 0; 0 0 1];
options.yoffset = 0;
options.deltat = 1e-4;
options.fill_fraction = .95;

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

% how many different categories do we have?
n_cat = length(A);

% make sure that all matrices are the same size
sz = size(A{1});
for i = 1:length(A)
    sz2 = size(A{i});
    assert(sz(1) == sz2(1),'Spike arrays not the same size')
    assert(sz(2) == sz2(2),'Spike arrays not the same size')
end

% make sure they're oriented correctly
for i = 1:length(A)
    sz = size(A{i});
    if sz(1) > sz(2)
        A{i} = A{i}';
    end
    ntrials(i) = size(A{i},1);
end

% determine type of input

if nanmax(A{1}(:)) > 1
    % data are spiketimes, with NaN or zero padding 
    % make sure all data is the same type TODO

    % convert to logical array
    max_size = 0;
    for i = 1:length(A)
        max_size = max([max_size nanmax(A{1})]);
    end
    for i = 1:length(A)
        B{i} = zeros(size(A{i},1),max_size);
        for j = 1:size(A{i},1)
            these_spikes = nonzeros(nonnans(A{i}(j,:)));
            if ~isempty(these_spikes)
                B{i}(j,these_spikes) = 1;
            end
        end

    end
    A = B;
elseif  all([0 1] == unique(A{1}(:)))
    % data is a logical array
else
    error('unrecognised data type')
end


for j = 1:length(A)
    for i = 1:ntrials(j)

        st = find(A{j}(i,:));
        x = reshape([st;st;NaN(1,length(st))],1,[]);
        y = reshape([(options.yoffset+i-1+zeros(1,length(st))); (options.yoffset+i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
        y(y==max(y)) = min(y)+options.fill_fraction*(max(y)-min(y));
     
        plot(x*options.deltat,y,'Color',options.Color(1,:)), hold on

    end
end



