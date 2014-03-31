% created by Srinivas Gorur-Shandilya at 11:39 , 24 January 2014. Contact me at http://srinivas.gs/contact/
% small wrapper function to compute rsquare between 2 input vectors using built-in MATLAB code
function [r] = rsquare(x,y)
x = x(:);
y = y(:);

% ignore NaNs
deletethis = find(isnan(x));
deletethis = unique([deletethis find(isnan(y))]);
x(deletethis) = [];
y(deletethis) = [];

[~, r]=fit(x,y,'Poly1');
r = r.rsquare;