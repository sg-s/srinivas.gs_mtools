% stabiliseImageSequence.m
% stabilizes an image sequence using image registration
% 
% created by Srinivas Gorur-Shandilya at 1:32 , 02 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [stabilised_images] = stabiliseImageSequence(images)

reference_image = squeeze(images(:,:,1));
threshold = prctile(reshape(reference_image,1,[]),60);
reference_image = single(reference_image>threshold);

stabilised_images = images;
[o,m]=imregconfig('monomodal');

for i = 2:size(images,3)
	textbar(i-1,size(images,3)-1);
	b = squeeze(images(:,:,i));
	threshold = prctile(reshape(b,1,[]),60);
	b = single(b>threshold);
	tform = imregtform(b,reference_image,'rigid',o,m,'PyramidLevels',4);
	stabilised_images(:,:,i) = imwarp(squeeze(images(:,:,i)),tform,'OutputView',imref2d(size(b)));
end	