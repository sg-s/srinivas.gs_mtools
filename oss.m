function [oslash] = oss()
if ispc == 1
    oslash = '\';
elseif isunix == 1
     oslash = '/';
 elseif ismac == 1
     oslash = '/';
end