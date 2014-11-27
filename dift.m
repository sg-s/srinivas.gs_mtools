% dift.m
% dift.m is a function that differentiates the time series x,
% where elements of x are located at corresponding times t
% update to dift.m on last edit @ 01:37 on Wednesday the 31th 
% now supports the differentiation of matrices, 
% treating each row as a different time series. 
function dx = dift(x,t)
if ~nargin
	help dift
	return
end

rot=0;
s = size(x);
if s(2) > s(1)
    % bad. rotate matrix
    x = x';
    rot=1; % this tells it to rotate the output back
else
end
xlength = max(s);% assumed to be length of time series. 
xwidth = min(s); %assumed to be the number of time series in matrix x
dx = zeros(xlength - 1, xwidth);
ddx = diff(x);
dt = diff(t);
s = size(dt);
if s(2) > s(1)
    % bad. rotate matrix
    dt = dt';
else
end
for i = 1:xwidth
    dx(:,i) = ddx(:,i)./dt;
end
if rot == 1
    dx = dx';
end