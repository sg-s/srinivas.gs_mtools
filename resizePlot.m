% 
% 
% created by Srinivas Gorur-Shandilya at 3:23 , 05 October 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function  [] = resizePlot(plot_handle)

assert(strcmp(class(plot_handle),'matlab.graphics.axis.Axes'),'First argument should be a handle to axis')

figure('outerposition',[0 0 500 800]); hold on

