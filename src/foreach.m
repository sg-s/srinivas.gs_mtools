% do something for each element of x
% where x is some iterable 
function y = foreach(x,f, args)

arguments
	x
	f (1,1) function_handle
	args.IgnoreOutput (1,1) logical = false
end


if args.IgnoreOutput
	for i = numel(x):-1:1
		f(x(i));
	end
else

	for i = numel(x):-1:1
		y(i) = f(x(i));
	end

end