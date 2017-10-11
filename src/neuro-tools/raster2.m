% raster2.m
% makes a raster plot of two different neurons. A (or B) can be either a logical matrix with 1 where a spike occurs, or long (zero padded) matrices of spike times. The time step is assumed to be 1e-4s if not specified
% This function is designed to be faster the the original raster
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 


function raster2(A,B,varargin)


% options and defaults
options.colour = [1 0 0; 0 0 1];
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



% plot A and B spikes
s = size(A);
if s(1) > s(2)
    A = A';
end
ntrials = size(A,1);

% if A and B are zero-padded spiketimes, convert them into logical arrays 
if max(max(A)) > 1
    t_end = max([max(max(A)) max(max(B))]);
    new_A = zeros(ntrials,t_end);
    for i = 1:ntrials
        new_A(i,nonzeros(A(i,:))) = 1; 
    end
    A = new_A;
end

for i = 1:ntrials
    A(i,isnan(A(i,:))) = 0;
    st = find(A(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(options.yoffset+i-1+zeros(1,length(st))); (options.yoffset+i-1+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    y(y==max(y)) = min(y)+options.fill_fraction*(max(y)-min(y));
 
    plot(x*options.deltat,y,'Color',options.colour(1,:)), hold on

end

s = size(B);
if s(1) > s(2)
    B = B';
end
ntrials = size(B,1);
for i = 1:ntrials
    B(i,isnan(B(i,:))) = 0;
    st = find(B(i,:));
    x = reshape([st;st;NaN(1,length(st))],1,[]);
    y = reshape([(options.yoffset+ntrials-1+i+zeros(1,length(st))); (options.yoffset+ntrials-1+i+ones(1,length(st))) ; (NaN(1,length(st))) ],1,[]);
    y(y==max(y)) = min(y)+options.fill_fraction*(max(y)-min(y));

    plot(x*options.deltat,y,'Color',options.colour(2,:)), hold on

end

if nargin > 1
    % fix ylabels to reflect the fact that we are plotting both A and B spikes
    yt = get(gca,'YTick');
    ytlabel = {};
    for i = 1:length(yt)
        if yt(i) > width(A)
            ytlabel{i} = oval(yt(i)-width(A));
        else
            ytlabel{i} = oval(yt(i));
        end
    end
    set(gca,'YTick',yt,'YTickLabel',ytlabel)
end


