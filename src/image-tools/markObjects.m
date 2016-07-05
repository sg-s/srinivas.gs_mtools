% markObjects.m
% shows an image with objects as detected by regionprops
% usage: markObjects(im,r)
% 
% created by Srinivas Gorur-Shandilya at 3:06 , 02 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = markObjects(im,r)

imagesc(im), hold on
for j = 1:length(r)
	plot(r(j).Centroid(1),r(j).Centroid(2),'ro','MarkerSize',10)
end
axis image
axis ij