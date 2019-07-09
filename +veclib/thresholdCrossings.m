%   computes the time step(s) at which a time-series reaches a threshold value
%% Arguments:
%   V: the time-series as a vector
%   threshold: the threshold as a scalar, defaults to 0
%   mode: a character vector that determines whether to collect the first, last, or all  upward crossings
%     'all': all crossings (default)
%     'first': only the first crossing
%     'last': only the last crossing
%% Outputs:
%   crossings: indices of upwards crossings as an n x 1 vector, where n is the number of saved crossings
%
%% Examples:
%
%   [ons, offs] = thresholdCrossings(V, -50);
%   [ons, offs] = thresholdCrossings(V, -50, 'all');
%

function [ons, offs] = thresholdCrossings(V, threshold, mode)

  if nargin < 2
    threshold = 0;
  end

  if nargin < 3
    mode = 'all';
  end

  % output containers
  ons = [];
  offs = [];

  % check crossings in both directions, for each index
  for ii = 1:length(V)-1
    if V(ii) < threshold & V(ii+1) >= threshold
      ons(end+1) = ii+1;
    end
    if V(ii) > threshold & V(ii+1) <= threshold
      offs(end+1) = ii+1;
    end
  end

  switch mode
  case 'all'
    return
  case 'first'
    ons = ons(1);
    offs = offs(1);
  case 'last'
    ons = ons(end);
    offs = offs(end);
  otherwise
    error('unknown mode: please specify ''all'', ''first'', or ''last''');
  end

end % function
