% round off a number and convert to a string
% oval is a version of round, which rounds to how many ever significant digits you want and returns a string. supports fractions.
%
%
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
%
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function r = oval(a,s)
switch nargin
case 0
	help strlib.oval
	return
case 1
	if isvector(a) && length(a) > 1
		% this means oval should take the mean and the std. of the vector, and format that into a string and return it. 
		m = mean(a); s = std(a);
		m = oval(m,3); s = oval(s,2);
		r = strcat(m,'(',s,')');
		return
	else
		s = 2;
	end
case 2
otherwise
	error('Too many input arguments')
end

if a == 0
	r = '0';
	return
end
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
