% isMATFileCompressed.m
% determines if a .mat file is compressed or not by reading HDF5 info
% only works on v7.3+ files (HDF5 files)
% 
% usage:
%
% [is_compressed] = isMATFileCompressed(file_name)
% returns a logical 
%
% [is_compressed,file_names] = isMATFileCompressed(folder_name)
% returns a vector corresponding to file_names, where file_names are the files it checked
% 
function [is_compressed,file_names] = isMATFileCompressed(file_name)

if isdir(file_name)
	% figure out how many files there are
	if strcmp(file_name(end),'/')
		file_name(end) = [];
	end
	allfiles = dir([file_name oss '*.mat']);
	is_compressed = NaN*(1:length(allfiles));
	file_names = cell(length(allfiles),1);
	for i = 1:length(allfiles)
		file_names{i} = [file_name oss allfiles(i).name];
		is_compressed(i) = isMATFileCompressed(file_names{i});
	end

elseif exist(file_name,'file') == 2
	% file_name is a file
	% check if it's a HDF5 file
	try
		hi = h5info(file_name);
		if isempty(hi.Datasets(1).Filters)
			is_compressed = 0;
			return
		else
			if strcmp(hi.Datasets(1).Filters.Name,'deflate')
				is_compressed = 1;
			end
		end

	catch
		disp([file_name ' is not a HDF5 file.'])
		is_compressed = NaN;
	end
end


