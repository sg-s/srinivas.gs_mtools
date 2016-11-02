% this function determines if source_code depends on list_of_function_names
% where source_code is a cell array with
% source_code{n} = 'string from nth line'
% and list_of_function_names is a cell array

function [is_dep] = isDep(source_code,list_of_function_names) 

assert(iscell(source_code),'expected source_code to be a cell array')
assert(iscell(list_of_function_names),'expected list_of_function_names to be a cell array')

is_dep = false(length(list_of_function_names),1);
bad_chars = char([48:57 65:90 95 97:122]); 


for i = 1:length(list_of_function_names)
	for j = 1:length(source_code)
		temp = strfind(source_code{j},list_of_function_names{i});
		if temp
			% check that we don't find a substring in a longer word
			ok = true;
			for k = 1:length(temp)
				try
					next_char = source_code{j}(temp(k)+length(list_of_function_names{i}));
					if ~isempty(strfind(bad_chars,next_char))
						ok = false;
					end
				catch
				end
			end

			if ok
			
				temp = temp(1); % this is to account for two invocations of one function in 1 line
				% keyword in this line
				if any(strfind(source_code{j},'%'))
					% there is a % somewhere 
					if temp < strfind(source_code{j},'%')
						% keyword is not a comment
						is_dep(i) = true;
					else
						% keyword is a comment. do nothing
					end
				else
					% no % anywhere, but keyword present
					is_dep(i) = true;
				end
			end
		end
	end
end
