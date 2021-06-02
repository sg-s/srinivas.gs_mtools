%%
% The purpose of this document is to test veclib, and also 
% to provide some documentation for it

%% veclib.interleave
% This function interleaves an arbitrary number of identically sized vectors in the order provided. 

X = ones(50,1);
Y = zeros(50,1);
Z = ones(50,1)*2;

I = veclib.interleave(X,Y,Z);
I(1:10)