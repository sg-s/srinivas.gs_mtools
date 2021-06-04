% do something for each element of x
% where x is some iterable 
function y = foreach(x,f)

arguments
	x
	f (1,1) function_handle
end


for i = numel(x):-1:1
	y(i) = f(x(i));
end

