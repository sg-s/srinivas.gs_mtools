function s = online()

s = 0;
if ispc
    [~,sa]=system('ping -w 500 -n 1 google.com');
    if isempty(strfind(sa,'0% loss'))
        s = 1;
    end
        
else
end
