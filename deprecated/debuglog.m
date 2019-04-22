% logging for debugging 
function debuglog(varargin)
try
    nid = 'unknown_user';
    try
        [~,nid] = system('whoami');
        nid = strtrim(nid);
    catch
    end
    try
        S = '';
        for i = 1:length(varargin)
            S = [S varargin{i} '/'];
        end
        writelog([nid '/' S]);
    catch
    end
catch
end