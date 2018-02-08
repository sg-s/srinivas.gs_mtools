% attempts to enable and make visible
% UI elements, graphics, etc in a MATLAB
% object 
%
% usage:
% enable(thing)
%
% Srinivas Gorur-Shandilya
% see also: disable 

function enable(thing)

try
	thing.Enable = 'on';
catch
end


try
	thing.Visible = 'on';
catch
end

try
	for i = 1:length(thing.Children)
		try
			thing.Children(i).Enable = 'on';
		catch
		end

		try
			thing.Children(i).Visible = 'on';
		catch
		end
	end

catch
end