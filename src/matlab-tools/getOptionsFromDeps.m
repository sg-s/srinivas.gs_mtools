% getOptionsFromDeps
% constructs an options structure from the dependencies of a given mfile
% 
% created by Srinivas Gorur-Shandilya at 9:22 , 15 March 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function options = getOptionsFromDeps(filename)

options = struct;

deps = getDependencies(filename);

for i = 1:length(deps)
	% read this file and see if it has any options
	source_code = '';
	try
		source_code = fileread(which(deps{i}));
	catch
	end
	if ~isempty(strfind(source_code,'options.'))
		fid = fopen(which(deps{i}), 'rt'); 
		source_code = textscan(fid,'%[^\n]'); %reads line by line 
		source_code = source_code{1};
		for j = 1:length(source_code)
			if strfind(source_code{j},'options.') == 1
				eval(source_code{j})
			end
		end
	end
end