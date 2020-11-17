% do something for each element of x
% where x is some iterable 
function y = foreach(x,f)

arguments
	x
	f (1,1) function_handle
end


y = repmat(f(x(1)),numel(x),1);
for i = 2:numel(x)
	y(i) = f(x(i));
end

