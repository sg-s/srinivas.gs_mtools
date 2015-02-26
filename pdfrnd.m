%%pdfrnd(x, px, sampleSize): return a random sample of size sampleSize from 
%%the pdf px defined on the domain x. 

%{
Joshua Stough
Washington and Lee University
August 2012

Generate random samples given a pdf.  The x and p(x) are specified in the
arguments.  See inverse transform sampling, gaussdis, gammadis. 

Examples:
X = pdfrnd(0:.1:20, gammadis(3,2, 0:.1:20), 100000);
figure, hist(X, 100);
%X will be 100000 samples from gamma distribution with a/k = 3, b/Theta =
%2.

X = pdfrnd(-10:.1:10, gaussdis(2, 3, -10:.1:10), 100000);
figure, hist(X, 100);
%X will be 100000 samples from a gaussian distribution with mean 2, var 3.
%Should be roughly equivalent to X = sqrt(3)*randn(100000, 1) + 2;
%}

function [X] = pdfrnd(x, px, sampleSize)
    cdf = cumsum(px);
    cdf = cdf/sum(cdf);
    cdf = cdf/max(cdf);

    rnd = rand(sampleSize, 1);

    % clip the cdf so that we ignore areas with zero pdf
    a = find(diff(cdf)==0,1,'first');
	z = find(diff(cdf)==0,1,'last');
	[~,m]=max(px);

	if isempty(a) && isempty(z)
		% no zeros in pdf, proceed
    	X = interp1(cdf, x, rnd, 'linear', 0);
	elseif isempty(a)
		disp('39')
		keyboard
	elseif isempty(z)
		disp('41')
		keyboard
	else
		% check if a and z are on either side of m
		if min([a z]) > m
			cdf = cdf(1:a);
			x = x(1:a);
			X = interp1(cdf, x, rnd, 'linear', 0);
		else
			disp('49')
		end

	end



end
