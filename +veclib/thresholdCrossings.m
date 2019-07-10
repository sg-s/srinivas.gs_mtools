%   computes the time step(s) at which a time-series reaches a threshold value
%% Arguments:
%   V: the time-series as a vector
%   threshold: the threshold as a scalar, defaults to 0
%   mode: a character vector that determines whether to collect the first, last, or all  upward crossings
%     'all': all crossings (default)
%     'first': only the first crossing
%     'last': only the last crossing
%   k: a positive integer
%     returns at most the first k threshold crossings
%% Outputs:
%   crossings: indices of upwards crossings as an n x 1 vector, where n is the number of saved crossings
%
%% Examples:
%
%   crossings = thresholdCrossings(V, -50);
%   crossings = thresholdCrossings(V, -50, 'first');
%   crossings = thresholdCrossings(V, -50, 7, 'first');
%

function crossings = thresholdCrossings(V, threshold, k, mode)

  if ~exist('threshold', 'var')
    threshold = 0;
  end

  if ~exist('mode', 'var')
    mode = 'all';
  end

  if ~exist('k', 'var')
    k = Inf;
  end

  % output containers
  crossings = [];
  % offs = [];

  % check crossings in both directions, as specified by mode
  switch mode
  case 'all'
    crossings   = find(diff(V > threshold) ~= 0, k) + 1;
    % offs  = find(diff(V < threshold) ~= 0, k) + 1;
  case 'first'
    crossings   = find(diff(V > threshold) ~= 0, k, 'first') + 1;
    % offs  = find(diff(V < threshold) ~= 0, k, 'first') + 1;
  case 'last'
    crossings   = find(diff(V > threshold) ~= 0, k, 'last') + 1;
    % offs  = find(diff(V < threshold) ~= 0, k, 'last') + 1;
  otherwise
    error('unknown mode: please specify ''all'', ''first'', or ''last''');
  end

end % function
