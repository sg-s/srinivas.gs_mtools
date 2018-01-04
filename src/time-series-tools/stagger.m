% stagger.m
% converts into a vector into a matrix
% where we take a bin and slide it over the vector
% usage:
% Y = stagger(X,bin_size,slide_step)
%
% where X is a vector
% bin_size and slide_step are integers
% and Y is a NxM matrix where
% N = bin_size
% M ~ (length(X) - bin_size)/slide_step
%
% stagger uses a parallel pool if it is available
% to speed up the rearrangement 
% 
% Srinivas Gorur-Shandilya
% https://srinivas.gs/

function Y = stagger(X, bin_size, slide_step)

assert(isvector(X),'first argument should be a vector')
X = X(:);
assert(isscalar(bin_size) && isint(bin_size),' bin_size should be a scalar integer')
assert(isscalar(slide_step) && isint(slide_step),' slide_step should be a scalar integer')

step_starts = 1:slide_step:(length(X) - bin_size);
M = length(step_starts);

if issparse(X)
	Y = sparse(bin_size,M);
else
	Y = NaN(bin_size,M);
end

p = gcp('nocreate');

if isempty(p)
	for i = 1:M
		Y(:,i) = X(step_starts(i):step_starts(i) - 1 + bin_size);
	end
else
	parfor i = 1:M
		Y(:,i) = X(step_starts(i):step_starts(i) - 1 + bin_size);
	end
end