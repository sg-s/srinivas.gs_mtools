%% veclib
% The purpose of this document is to test veclib, and also 
% to provide some documentation for it

%% veclib.interleave
% This function interleaves an arbitrary number of identically sized vectors in the order provided. 

X = ones(50,1);
Y = zeros(50,1);
Z = ones(50,1)*2;

I = veclib.interleave(X,Y,Z);

%%
% and we get:

I(1:10)

%% veclib.chunk
% Let's imagine you have a long vector, and you want to chunk 
% it into smaller bits for analysis. You can't simply use 
% reshape, because the length of the vector may not be an 
% integer multiple of your bin size. That's where `veclib.chunk` 
% comes to the rescue.

X = randn(129,1);
Y = veclib.chunk(X,10);

%%
% If we inspect the size of Y we see:

size(Y)