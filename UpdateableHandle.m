% an abstract class that grants objects
% the ability to update over the internet,
% and uninstall themselves
%
% usage:
% self.update()
% self.uninstall()
%
% this will work if the class was installed
% using git, or if installed as a MATLAB toolbox


classdef (Abstract) UpdateableHandle < handle
 


methods (Static)

	function update(url)


		original_dir = pwd;


		% figure out the name and location of the class calling this method
		d = dbstack('-completenames');
		code_dir = fileparts(d(end).file);
		[~,dir_name]=fileparts(code_dir);
		if any(strfind(dir_name,'@'))
			code_dir = fileparts(code_dir);
		end

		[~,repo_name] = fileparts(code_dir);

		% check if there exists a .git folder


		if exist([code_dir filesep '.git'],'dir') == 7
			% .git exists
			[~,o] = system('git');

			if any(strfind(o,'checkout'))
				% git is installed
				% attempt to pull
				!git stash
				!git clean -f -d
				!git pull
			else
				cd(original_dir)
				error('.git folder exists, but git is not installed. Cannot update.')
			end

		else


			% no .git. maybe toolbox?
			toolboxes = matlab.addons.toolbox.installedToolboxes;
			if any(strcmp({toolboxes.Name},repo_name))
				% installed as a toolbox
				UpdateableHandle.uninstall(repo_name)

				% download the new toolbox
				websave([repo_name '.mltbx'],[url '/releases/download/latest/' repo_name '.mltbx']);

				assert(exist([repo_name '.mltbx']) == 2,'Failed to download toolbox')

				t = matlab.addons.toolbox.installToolbox([repo_name '.mltbx']);

				disp('Installed version:')
				disp(t.Version)


			else
				cd(original_dir)
				error('class is not in a git repo, nor is it in a toolbox. Cannot update')
			end
		end


	


	end



	function uninstall(toolbox_name)

		toolboxes = matlab.addons.toolbox.installedToolboxes;

		% go somewhere safe
		if ispc
			gohere = winqueryreg('HKEY_CURRENT_USER',['Software\Microsoft\Windows\CurrentVersion\','Explorer\Shell Folders'],'Personal');
		else
			gohere = '~';
		end
		cd(gohere)

		% remove all toolboxes with "xolotl" in it
		for i = 1:length(toolboxes)
			if strcmp(toolboxes(i).Name,toolbox_name)
				matlab.addons.toolbox.uninstallToolbox(toolboxes(i));
			end
		end


	end

end % methods


end % classdef





