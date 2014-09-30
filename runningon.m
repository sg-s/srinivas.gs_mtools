% runningon is a small function that displays the name of the computer
% running on. it uses getComputerName
% it also has a built in killswitch to prevent anything running on
% login@mpi-ds
function [] = runningon()
disp('Running on:')
if isunix
    disp(getComputerName)
    if strcmp(getComputerName, 'login') == 1
        error('JFC! Running on goddamn login. Comitting harakiri...')
        return
    end
elseif ismac
     disp(getComputerName)
elseif ispc
    disp('virtualbox@odin')
end
