function [build_numbers, req_update] = checkDeps(toolboxes)

build_numbers = NaN(length(toolboxes),1);
req_update = false(length(toolboxes),1);

try
    if online
        for i = 1:length(toolboxes)
            try
                [~,p]=searchPath(toolboxes{i});
                if isempty(p)
                    disp([toolboxes{i} ' not installed'])
                else
                    build_numbers(i) = str2double(fileread([p oss 'build_number']));
                    v = checkForNewestVersionOnGitHub(['/sg-s/' toolboxes{i}]);
                    if v > build_numbers(i)
                        disp(['A new version of ' toolboxes{i} ' is available: build' oval(v)])
                        disp(['You have build ' oval(build_numbers(i))])

                        update_string = ['install -f sg-s/' toolboxes{i}]; 
                        disp_string = ['<a href="matlab:' update_string '">This toolbox may be automatically updated. Click here to manually update now.</a>'];
                        disp(disp_string)
                        req_update(i) = true;
                    else
                        disp(['You have the latest version of ' toolboxes{i} ' -- build ' oval(build_numbers(i))])
                    end
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