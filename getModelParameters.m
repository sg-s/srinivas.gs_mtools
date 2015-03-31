% getModelParameters.m
% usage:
% p=getModelParameters(modelname);
% returns a structure p that modelname needs
% it works by reading modelname.m and figuring it out
% works nice with Manipulate.m and FitModel2Data.m
% assumes that modelname is of the form modelname(s,p)
%
% created by Srinivas Gorur-Shandilya at 3:20 , 22 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function p = getModelParameters(modelname)
switch nargin
	case 0
		help getModelParameters
	case 1
		if ~ischar(modelname)
			error('Argument must be a string')
		end
		if any(strfind(modelname,'.m'))
		else
			if ~exist(modelname)
				error('Unknown function')
			end
			modelname = [modelname '.m'];
		end
end


txt=fileread(modelname);
a = strfind(txt,'p.');
p = [];

for i = 1:length(a)
	this_snippet = txt(a(i)+2:length(txt));
	% stupid fucking underscores not detected by alphanum
	this_snippet = strrep(this_snippet,'_','underscore');
	f=this_snippet(1:(find(~isstrprop(this_snippet,'alphanum'),1,'first')-1));
	f = strrep(f,'underscore','_');
	try
		eval(strcat('p.',f,'=rand;'));
	catch
		
	end
end

% force this to respect model bounds, if any
[lb, ub] = getBounds(modelname);
fn_ub = fieldnames(ub);
fn_lb = fieldnames(lb);
fn = intersect(fn_ub,fn_lb);

for i = 1:length(fn)
	if eval(strcat('(lb.',fn{i},'<p.',fn{i},')')) || eval(strcat('(ub.',fn{i},'>p.',fn{i},')'))
		eval(strcat('p.',fn{i},'=mean([lb.',fn{i},' ub.',fn{i},']);'))
	end
end

