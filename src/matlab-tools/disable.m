% attempts to disable 
% UI elements, graphics, etc in a MATLAB
% object 
%
% usage:
% disable(thing)
%
% Srinivas Gorur-Shandilya
% see also: enable 

function disable(thing)

try
	thing.Enable = 'off';
catch
end


try
	for i = 1:length(thing.Children)
		try
			thing.Children(i).Enable = 'off';
		catch
		end

		try
			thing.Children(i).Visible = 'off';
		catch
		end
	end

catch
end