% findData.m
% finds indices of a structure that have non empty fields. 
% 
% created by Srinivas Gorur-Shandilya at 12:47 , 28 August 2013. Contact me
% at http://srinivas.gs/contact/
% finds which elements in a given structure contain non-empty matrices.
% usage: have_data  = find_data(data)
% where data is a structure array
% 
function have_data  = findData(data)
if ~nargin
	help findData
	return
end
l = length(data);
have_data = [];
f= fieldnames(data);
for i = 1:l
    eval(strcat('d=isempty(data(',mat2str(i),').',f{1},');'));
    if ~d
        have_data = [have_data i];
    end
    
end