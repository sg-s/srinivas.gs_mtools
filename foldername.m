% returns the current folder's name
function [f] = foldername()
temp = cd;
s=strfind(temp,oss);
f = temp(s(end)+1:end);