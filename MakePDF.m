% MakePDF.m
% a wrapper for MATLAB's publish() function, it makes a PDF directly from the .tex that MATLAB creates and cleans up afterwards.
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = MakePDF(filename);

% compile to .tex
options.showCode = false;
options.format = 'latex';
options.imageFormat= 'pdf';
options.figureSnapMethod=  'print';
options.stylesheet = 'srinivas_latex.xsl';

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