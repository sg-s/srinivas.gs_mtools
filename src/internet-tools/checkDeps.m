function [build_numbers] = checkDeps(toolboxes)

build_numbers = NaN(length(toolboxes),1);

try
    if online
        for i = 1:length(toolboxes)
            try
                [~,p]=searchPath(toolboxes{i});
                build_numbers(i) = str2double(fileread([p oss 'build_number']));
                v = checkForNewestVersionOnGitHub(['/sg-s/' toolboxes{i}]);
                if v > build_numbers(i)
                    disp(['A new version of ' toolboxes{i} ' is available: build' oval(v)])
                    disp(['You have build ' oval(build_numbers(i))])

                    update_string = ['install -f sg-s/' toolboxes{i}]; 
                    disp_string = ['<a href="matlab:' update_string '">click here to update</a>'];
                    disp(disp_string)
                else
                    disp(['You have the latest version of ' toolboxes{i} ' -- build ' oval(build_numbers(i))])
                end
            catch
                error('Missing toolboxes? Try updating and re-installing all toolboxes.')
            end
        end
    else
        warning('Could not check for updates.')
    end
catch
    warning('Could not check for updates.')
end