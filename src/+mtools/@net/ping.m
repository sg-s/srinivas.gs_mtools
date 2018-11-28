% mtools.net.ping
% 
% pings a remote server
% to check that it's online

function ok = ping(server_name)

[e,~]=system(['ping ' server_name ' -c 1']);
if e == 0
	ok = true;
else
	ok = false;
	disp(['Could not contact ' server_name ' -- check that you have the right name and that it is reachable'])
end