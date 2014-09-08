% MakePDF.m
% a wrapper for MATLAB's publish() function, it makes a PDF directly from the .tex that MATLAB creates and cleans up afterwards.
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = MakePDF(filename)

switch nargin
case 0
	help MakePDF
case 1
	% check if file exists
	if exist(filename,'file') ~= 2
		help MakePDF
		error('Cant find the file you told me to compile')
	end
otherwise
	help MakePDF
	error('Too many inputs')
end

close all 

% compile to .tex
options.showCode = false;
options.format = 'latex';
options.imageFormat= 'pdf';
options.figureSnapMethod=  'print';

% use a custom stylesheet, if it exists
a = dir('*.xsl');
switch length(a)
	case 0
		% no custom stylesheet
	case 1
		% use this!
		options.stylesheet = a.name;
	case 2
		error('Too many custom stylesheets in current directory. MakePDF does not know what to do.')
end


f=publish(filename,options);

% tell stupid MATLAB to get the path right
PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/texbin']); 

% move to the correct directroy
cd('html')

% convert the .tex to a PDF
es = strkat('pdflatex ',f)
unix(es)

% clean up
cd('..')
CleanPublish;
close all