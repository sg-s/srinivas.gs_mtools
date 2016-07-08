% class definition for dataManager 
% dataManager is a tool for using hashes to interface between your code and your data
% the point is to make your code agnostic to WHERE the data is, but sensitive to WHAT the data is
% 
% see: https://github.com/sg-s/data-manager
% for more docs
% 
% created by Srinivas Gorur-Shandilya. Contact me at http://srinivas.gs/contact/


classdef hashCache
   properties
   end
   
   methods

      function [] = add(hc,key,value)
      	
      end % end function add



      function [] = view(hc)
        	% check for a cache
        	root = [pwd oss];
          	if  exist([root '.cache'],'dir') == 7
          		% get a list of all files
          		allfiles = dir([root '.cache' oss '*.mat']);
          		if isempty(allfiles)
          			disp('Cache empty.')
          		else
	          		% strip the .mat from them
	          		for i = 1:length(allfiles)
	          			allfiles(i).name = strrep(allfiles(i).name,'.mat','');
	          		end
	          		disp('Contents of cache:')
	          		disp({allfiles.name}')
	          	end
          	else
          		disp('Cache empty.')
          		mkdir([root '.cache'])
          	end

      end % end function view


   end % end methods
end % end classdef