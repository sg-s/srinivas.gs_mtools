% labels a vector by percentile bin
% usage:
% l = labelByPercentile(x,nbins);
% returns a vector l as long as x, with nbins different symbols, according to the precentile bin in which x(i) is in 
% created by Srinivas Gorur-Shandilya at 9:55 , 25 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function l = labelByPercentile(x,nbins)

if ~nargin
	help labelByPercentile
	return
end

assert(isvector(x),'First argument should be a vector')
assert(isscalar(nbins),'Second argument should be a vector')
assert(nbins>1,'nbins should be greater than 1')

x = x(:);
l = nbins+zeros*x;

% sort
[~,idx] = sort(x);
c = floor(length(x)/nbins);


for i = 1:nbins
	a = c*(i-1)+1;
	z = a+c-1;
	l(idx(a:z),1) = i;
end