function [p] =  struct2mat(p)
p = struct2cell(p);
p = [p{:}];