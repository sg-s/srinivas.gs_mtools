% textbar is the text equivalent of waitbar.
% usage: insert textbar(i,imax) in the first line of your for loop
% where the for loop is like for i = 1:1:imax
% it uses minimal resources to display an elegant progress bar
% textbar version 0.1.1
% created by Srinivas Gorur-Shandilya at 14:50 , 02 September 2013. Contact
% me at http://srinivas.gs/contact/
% known issues:
% - if imax > 100, the progress bar grows a bit at 10%
% - does not work for istep ~= 1
% - does not work when istart ~= 1
% - If you run MATLAB via ssh over a slow connection, output may be mangled
% - It WILL slow down your code. Don’t use if you have millions of iterations
function [] = textbar(i,imax,message)
%% code.
if imax < 100
    %% show fraction
    % figure out how much is on the screen
    if i > 1
        % delete old progress
        dop = length(strcat(mat2str(imax),mat2str(i-2))) + 27;
        printthis = '';
        for bs = 1:dop
            printthis = strcat(printthis,'\b');
        end
        % write new progress
        progress = floor((i/imax)*20);
        if progress > 0
            pbar = '';
            for pi = 1:progress
                pbar = strcat(pbar,'=');
            end
            rbar = '';
            for ri = 1:20-progress
                rbar = strcat(rbar,'-');
            end
            printthis = strcat(printthis,pbar,rbar);
        else
            printthis = strcat(printthis,'--------------------');
        end
        printthis = strcat(printthis,']   (',mat2str(i-1),'/', mat2str(imax),')');
        
    else
        % first run
        printthis = (strcat('[--------------------]   (',mat2str(i-1),'/', mat2str(imax),')'));
    end
    if i == imax
        dop = length(strcat(mat2str(imax),mat2str(i-2))) + 28;
        printthis = '';
        for bs = 1:dop
            printthis = strcat(printthis,'\b');
        end
        
    end
else
    %% show percentage
    disi = floor((i/imax)*100);
    
    % figure out how much is on the screen
    if i > 1
        op = length(mat2str(floor((((i-1)/imax)*100))));
        % delete old progress
        dop = 3 + op + 24;
        printthis = '';
        for bs = 1:dop
            printthis = strcat(printthis,'\b');
        end
        % write new progress
        progress = floor((disi/100)*20);
        if progress > 0
            pbar = '';
            for pi = 1:progress
                pbar = strcat(pbar,'=');
            end
            rbar = '';
            for ri = 1:20-progress
                rbar = strcat(rbar,'-');
            end
            printthis = strcat(printthis,pbar,rbar);
        else
            printthis = strcat(printthis,'--------------------');
        end
        printthis = (strcat(printthis,']   (',mat2str(disi),'%%)'));
        
    else
        % first run
        printthis = (strcat('[--------------------]   (',mat2str(disi),'%%)'));
    end
    if i == imax
        dop = length(mat2str(floor((((i-1)/imax)*100)))) + 29;
        printthis = '';
        for bs = 1:dop
            printthis = strcat(printthis,'\b');
        end
        printthis = strcat(printthis,'DONE.\n');
    end
end
fprintf(printthis)
