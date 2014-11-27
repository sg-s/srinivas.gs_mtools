% header is a neat little function
% that replaces all the labourious little snippets i 
% used to insert in code before
% it supports the following:
% 0. clears screen
% 1. displays name of file
% 2. displays computer running on + autokill if computer is login
% 3. displays last edit---automatically!!! 
function [graphics] = header(varargin)
% clear screen
clc
close all
if nargin == 1
    mynameis = cell2mat(varargin(1));
    % display name of file
    disp(strcat(mynameis,'.m starting...'))
    % runningon
    runningon;
    % last edit
    le = dir(strcat(mynameis, '.m'));
    if ~isempty(le)
        disp('Last Edited on:')
        disp(le.date)
    else
        disp('Cannot read last edit info. This may be because this instance is running compiled code, as opposed to a .m from within MATLAB.')
    end
else
    runningon;
    disp('Starting on the MATLAB Shell...')
end
if usejava('awt')
    graphics = 1;
    close all
    disp('Graphics supported. Java Window server detected...')
else
    graphics = 0;
    
    disp('Graphics unsupported. No plots possible.')
end