% metadata2timestamps.m
% converts a metadata file created by Micro-Manager into useful timestamps
% 
% created by Srinivas Gorur-Shandilya at 2:40 , 01 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [andor_elapsed_time,elapsed_time,absolute_time] = metadata2timestamps(txt)


assert(ischar(txt),'Input should be a string (char)')

token = '"Andor-ElapsedTime-ms"';
loc = strfind(txt,token);
andor_elapsed_time = NaN*loc;

for i = 1:length(loc)
	temp = txt(loc(i)+length(token)+1:loc(i)+length(token)+50);
	andor_elapsed_time(i) = str2num(strrep(temp(1:strfind(temp,',')-1),'"',''));
end
andor_elapsed_time = andor_elapsed_time - andor_elapsed_time(1);
andor_elapsed_time = andor_elapsed_time*1e-3;


token = '"ElapsedTime-ms"';
loc = strfind(txt,token);
elapsed_time = NaN*loc;

for i = 1:length(loc)
	temp = txt(loc(i)+length(token)+1:loc(i)+length(token)+50);
	elapsed_time(i) = str2num(strrep(temp(1:strfind(temp,',')-1),'"',''));
end
elapsed_time = elapsed_time - elapsed_time(1);
elapsed_time = elapsed_time*1e-3;

token = '"Time":';
loc = strfind(txt,token);
absolute_time = NaN*loc;

for i = 1:length(loc)
	temp = txt(loc(i)+length(token)+1:loc(i)+length(token)+50);
	absolute_time(i) = datenum((strrep(temp(1:strfind(temp,'-0400')-1),'"','')));
end
absolute_time = absolute_time(3:2:end);

