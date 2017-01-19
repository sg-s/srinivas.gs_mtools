% multi-core TSNE wrapper
% 
% 
% created by Srinivas Gorur-Shandilya at 2:04 , 02 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function R = mctsne(Vs)

save('Vs.mat','Vs')

system([fileparts(which('mctsne')) oss 'mctsne.py'])

% read the solution
R = h5read('data.h5','/R');

% clean up
delete('data.h5')
delete('Vs.mat')

