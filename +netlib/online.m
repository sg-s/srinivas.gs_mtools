% checks to see if your computer is online
% pings google.com, and waits for a second or less
% returns 0 if not online, 1 if online
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function s = online()
s = 0;
if ispc
    [~,sa]=system('ping -w 500 -n 1 google.com');
    if ~isempty(strfind(sa,'0% loss'))
        s = 1;
    end
else
	[~,sa]= system('ping -t 1 -q google.com | grep "0.0% packet loss" | wc -l');
	if ~isempty(strfind(sa,'1'))
		s = 1;
	end
end
