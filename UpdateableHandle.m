% a class that makes objects updatable
% (as in, from the internet, to new version)

classdef (Abstract) UpdateableHandle < handle
 


methods

	function update(self)

		original_dir = pwd;

		try
			code_loc = fileparts(which(class(self)));
			cd(code_loc)
			system('git reset --hard');
			system('git clean -f -d');
			system('git pull');
		catch
			warning('could not update.')
		end
		cd(original_dir)


	end

end




end % classdef