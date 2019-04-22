% cleanPublish removes all the junk created by MATLAB's publish() function in the html/ folder in the current directory. Make sure you compile the PDF before running this! 
% usage: cleanPublish; 
% assumes you have a folder called "html" in your cd
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function clean()

if exist('html','dir') == 7
	% delete away
	delete('html/*.gz')
	delete('html/*.log')
	delete('html/*.tex')
	delete('html/*.aux')

	a=dir('html/*_*.pdf');
	for i = 1:length(a)
		z = regexp(a(i).name,'.pdf');
		if ~isnan(str2double((a(i).name(z-2:z-1))))
			delete(strcat('html/',a(i).name))
		end
	end

	if verLessThan('matlab','8.4')
	else
		% have to clean up pngs too
		delete('html/*.png')
	end
end