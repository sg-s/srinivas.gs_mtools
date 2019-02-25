% funeval
% recursively evaluate a function till it 
% stops being a function handle

function V = funeval(f)
	while isa(f,'function_handle')
		f = f();
	end
	V = f;
end