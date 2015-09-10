% makePDF.m
% a wrapper for MATLAB's publish() function, it makes a PDF directly from the .tex that MATLAB creates and cleans up afterwards.
% needs pdflatex installed. Will not work on Windows.
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = makePDF(filename)

switch nargin
case 0
	% run on the last modified file
	d = dir('*.m');

	% find the last modified file
	[~,idx] = max([d.datenum]);

	% name of file
	try
		filename = d(idx).name;
	catch
		error('MakdPDF could not figure out which document you want to publish. Specify explicitly.')
	end
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

orig_dir = cd;
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

% check to make sure all changes are committed to git
[~,m] = unix('git status | grep "modified" | wc -l');
if str2double(m) > 0
	error('You have unmodified files that have not been committed to your git repo. Cowardly refusing to proceed till you commit all files.')
end


f=publish(filename,options);



% tell stupid MATLAB to get the path right
PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/texbin']); 

% move to the correct directory
cd('html')

% convert the .tex to a PDF
es = strkat('pdflatex ',f);
unix(es);

% clean up
cd(orig_dir)
CleanPublish;
close all

% open the PDF
f = strrep(f,'.tex','.pdf');
open(f)