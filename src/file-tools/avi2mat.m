%% avi2mat.m
% converts a folder full of avi files to .mat files
% where each .mat file contains a 3D matrix containing the video
% we do this because we believe using matfile on this file is faster 
% than using VideoReader on the .avi file

function [] = avi2mat(path_name)

if ~nargin
	path_name = pwd;
end

assert(ischar(path_name),'Input argument must be a string')
assert(isdir(path_name),'Input must be a path to a folder')

% remove trailing slash
if strcmp(path_name(end),'/') ||  strcmp(path_name(end),'\')
	path_name = path_name(1:end-1);
end

% get all .avi files in the path
all_files = dir([path_name, oss, '*.avi']);

for i = 1:length(all_files)
	disp(all_files(i).name)

	% check if this .mat file already exists
	[~,temp]=fileparts(all_files(i).name);
	matfile_name = [path_name oss temp '.mat'];
	if exist(matfile_name,'file')==2
		disp('.mat file already exists. Skipping...')
	else
		% import using importdata
		disp('Importing data...')
		movie = importdata([path_name oss all_files(i).name]);

		% convert it into a 3D matrix
		disp('Converting to a 3D matrix...')
		images = zeros(size(movie(1).cdata,1),size(movie(1).cdata,2),length(movie),'uint8');
		for j = 1:length(movie)
			images(:,:,j) = movie(j).cdata;
		end
		clear movie

		% compute max, mean and std along time axis
		disp('Computing projections...')
		max_proj = max(images,[],3);
		mean_proj = mean(images,3);

		% save using the same name
		disp('Saving as a HDF5 .mat file...')
		
		save(matfile_name,'images','max_proj','mean_proj','-v7.3');
	end
end
