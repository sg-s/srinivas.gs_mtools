% oval.m
% created by G S Srinivas ( http://srinivas.gs ) @ 14:29 on Wednesday the
% 23th of February, 2011
% oval is a better version of round, which rounds to how manyever
% significant digits you want
% % created by Srinivas Gorur-Shandilya at 12:09 on 31-March-2014. Contact me at http://srinivas.gs/
% now with support for fractions
function [r] = oval(a,s)
% fix for negative numbers
if ischar(s)
	% a is a fraction, and we should parse it appropriately
	denom = 1;
	while floor(a*denom) ~= ceil(a*denom)
		denom = denom + 1;
	end
	num = a*denom;
	r = strcat(mat2str(num),'/',mat2str(denom));
else
	if a <0
		flip=1;
	else
		flip = 0;
	end
	a= abs(a);
	powerbase = round(log10(a));
	if powerbase > s  
	else
	    s = s - powerbase;
	end
	% get as many significant digits as needed before 0
	    a = round(a*10^(s));
	    % get back to the original number
	    r = mat2str(a*10^(-s));

	if flip
		r = strcat('-',r);
	end
end