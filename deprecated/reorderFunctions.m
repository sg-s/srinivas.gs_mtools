%% reorderFunctions
% reorder functions in a long mfile
% organises subfunctions by name, alphabetically 
% useful for organising large, single .m file programs

function [] = reorderFunctions(filename)

% first get the subfunctions
subfunction_names =  listSubFunctions(filename);

% remove the main function from here
subfunction_names(find(strcmp(subfunction_names,filename))) = [];


