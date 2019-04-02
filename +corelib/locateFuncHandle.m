% given a function handle, find where it is
function [func_loc, class_loc] = locateFuncHandle(func_handle)

func_loc = '';
class_loc = '';

assert( isa(func_handle,'function_handle'),'Input must be a function handle')


info = functions(func_handle);
if isempty(info.workspace)
	func_loc = info.file;
	return
end

% probably a method of a class. let's locate that
assert(isfield(info,'workspace'),'Expected info to contain a workspace field')
S = info.workspace{1};

fn = fieldnames(S);
fail = true;
for i = 1:length(fn)
	this_class = class(S.(fn{i}));

	if exist(this_class) == 2
		
		class_loc = which(this_class);
		class_loc = fileparts(class_loc);

		if ~isdir(class_loc)
			continue
		end

		fail = false;

		method_names = methods(this_class);

		for j = 1:length(method_names)
			if any(strfind(info.function,method_names{j}))

				if  exist([class_loc filesep method_names{j} '.m']) == 2
					func_loc = [class_loc filesep method_names{j} '.m'];
					return
				end

			end
		end


	end

end


if fail
	error('Could not determine location of function handle')
end

