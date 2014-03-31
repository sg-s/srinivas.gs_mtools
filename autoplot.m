% created by Srinivas Gorur-Shandilya at 18:45 , 06 February 2014. Contact me at http://srinivas.gs/contact/
% autoplot is a wrapper around subplot that only needs the total number of subplots and the index of the current subplot to build a figure with subplots.
function [h] = autoplot(n,thisplot,PreferLong)
if n > 18
	error('too many subplots!')
end
if nargin < 3
	PreferLong = 0;
end
switch n
	case 1
		a = 1; b=1;
	case 2
		a = 1; b=2;
	case 3
		a = 1; b=3;
	case 4
		a = 2; b=2;
	case 5
		a = 2; b=3;
	case 6
		a = 2; b=3;
	case 7
		a = 2; b=4;
	case 8
		a = 2; b=4;
	case 9 
		a = 3; b=3;
	case 10
		a = 2; b=5;
	case 11
		a = 3; b=4;
	case 12
		a = 3; b=4;
	case 13
		a = 3; b=5;
	case 14
		a = 3; b=5;
	case 15
		a = 3; b=5;
	case 16
		a = 4; b=4;
	case 17
		a = 3; b = 6;
	case 18
		a = 3; b = 6;
end
if PreferLong
	temp = a;
	a = b;
	b = temp;
end
h = subplot(a,b,thisplot);