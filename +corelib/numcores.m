% Find number of cores on a CPU
% 
function [logical_cores, physical_cores] = numcores()

core_info = evalc('feature(''numcores'')');
a = strfind(core_info,'detected');
z = strfind(core_info,'physical');
physical_cores = str2double(core_info(a(1)+9:z(1)-1));

z = strfind(core_info,'logical');
logical_cores = str2double(core_info(a(2)+9:z(1)-1));