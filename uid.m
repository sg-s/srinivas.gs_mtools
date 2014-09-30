%make a Unique ID every time this is run
% based on getComputerName, as well as the clock
function [u] = uid()
u = strcat(getComputerName, mat2str(round(abs(now-round(now))*1e14)));
