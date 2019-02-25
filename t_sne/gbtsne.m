function [yData,betas,P,errors] = gbtsne(data,varargin)
% run_tSne runs the t-SNE algorithm on an array of normalized wavelet amplitudes
% this version was written by Gordon Berman
%
%   Input variables:
%
%       data -> Nxd array of wavelet amplitudes (will normalize if
%                   unnormalized) containing N data points
%       parameters -> struct containing non-default choices for parameters
%
%
%   Output variables:
%
%       yData -> N x parameters.num_tsne_dim array of embedding results
%       betas -> Nx1 array of local region size parameters
%       P -> full space transition matrix
%       errors -> P.*log2(P./Q) as a function of t-SNE iteration
%
%
% (C) Gordon J. Berman, 2014
%     Princeton University



% options and defaults
options.num_tsne_dim = 2;
options.perplexity = 30;
options.sigmaTolerance = 1e-5;
options.relTol = 1e-4;
options.tsne_readout = 1;
options.momentum = .5;
options.final_momentum = .8;
options.mom_switch_iter = 250;
options.stop_lying_iter = 125;
options.max_iter = 400;
options.epsilon = 500;
options.min_gain = .01;
options.lie_multiplier = 4;

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



vals = sum(data,2);
if max(vals) > 1 || min(vals) < 1
    data = bsxfun(@rdivide,data,vals);
end

fprintf(1,'Finding Distances\n');
D = findKLDivergences(data);


fprintf(1,'Computing t-SNE\n');
[yData,betas,P,errors] = tsne_d(D,options);