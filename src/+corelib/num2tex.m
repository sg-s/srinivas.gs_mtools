% nicely formats a number for easy printing
% better than the built-in num2str
% which it uses
function T = num2tex(X)

assert(isscalar(X),'Input must be scalar')
assert(isnumeric(X),'Input must be numeric')

T = num2str(X,'%10.1e');

temp = strsplit(T,'e');
E = str2double(temp{2});

if E >= 3 | E <= -3
	% standard scientific notation

	% strip trailing zeros
	S = '';
	if strcmp(temp{2}(1),'-')
		S = '-';
		temp{2} = temp{2}(2:end);
	end

	temp{2} = strip(temp{2},'0');


	temp{2} = ['\times 10^{' S temp{2} '}'];

	T = [temp{1} temp{2}];
	return

end

switch E
	case -2
		T = num2str(X);
		return
	case -1
		T = num2str(X,2);
		return
	case 0
		T = temp{1};
		return
	case 1
		T = num2str(X,3);
		return
	case 2
		T = num2str(X,4);
		return

end
	


