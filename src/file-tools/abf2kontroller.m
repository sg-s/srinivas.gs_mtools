%% abf2kontroller.m
% converts ABF spike recordings to kontroller- and spikesort-compatible data
% usage: abf2kontroller(file_name)
% or abf2kontroller() will convert all files in the current folder
function abf2kontroller(varargin)


% options and defaults
options.sampling_rate = 1e4;
options.trigger_channels = 2;
options.data_channels = 1;
options.before_trigger_buffer = 1; % in seconds
options.use_trigger = true;

if nargout && ~nargin 
	varargout{1} = options;
    return
end

file_name = pwd;
if nargin
	% check if there is a file path somewhere
	if exist(varargin{1},'file') == 2
		file_name = varargin{1};
		varargin(1) = [];
	end
end

% validate and accept options
if iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end

if isdir(file_name)
	if ~strcmp(file_name(end),oss)
		file_name = [file_name oss];
	end
	allfiles = dir([file_name  '*.abf']);
	for i = 1:length(allfiles)
		p = [file_name  allfiles(i).name];
		try
			abf2kontroller(p,options);
		catch
			warning('Error in this file:')
			disp(allfiles(i).name)
		end
	end
	return
else
	disp(file_name)
	[d,~,h] = abfload(file_name);
	sr = ceil(length(d)/diff(h.recTime));
	time = (1/sr)*(1:length(d));
	t = linspace(0,max(time),max(time)*options.sampling_rate);

	data = zeros(length(t),size(d,2));
	for i = 1:size(d,2)
		data(:,i) = interp1(time,d(:,i),t);
	end
	d = data; clear data

	trigger_signal = d(:,options.trigger_channels);
	if width(trigger_signal) > 1
		error('Cant deal with multiple trigger signals: not coded')
	end

	trigger_signal = trigger_signal - min(trigger_signal);
	trigger_signal = trigger_signal/max(trigger_signal);
	trigger_signal(trigger_signal>0.5) = 1;
	trigger_signal(trigger_signal<1) = 0;

	if ~options.use_trigger
		trigger_signal = 0*trigger_signal;
	end

	clear ControlParadigm data
	data = struct;


	if ~options.use_trigger
		data.voltage = d(:,options.data_channels)';
		ControlParadigm.Outputs = 0*data.voltage;
		if length(h.tags) == 0
			ControlParadigm.Name = 'dummy';
		else
			ControlParadigm.Name = h.tags(1).comment;
		end
	elseif length(h.tags) > 0

		disp('Tags/metadata found!')

		% check that the number of tags is equal to the numer of triggers
		[ons,offs] = computeOnsOffs(trigger_signal);

		keyboard

		if length(h.tags) ~= length(ons)
			disp('!!! Something wrong with trigger signals...attempting to fix.')
			ons((offs-ons)<500) = [];
		end

		if length(ons) == length(h.tags)
			ons = [ons; length(trigger_signal)];
		else
			error('Trigger signal makes no sense.')
		end



		for j = 1:length(ons)-1
			a = ons(j) - options.before_trigger_buffer*options.sampling_rate;
			if a < 1
				a = 1;
			end
			z = ons(j+1);
			data(j).voltage = d(a:z,options.data_channels)';

			ControlParadigm(j).Outputs = d(a:z,options.trigger_channels)';
			ControlParadigm(j).Name = h.tags(j).comment;

		end
		
	else 
		disp('No annotation, putting everything into placeholder paradigms...')
		
		data.voltage = d(:,options.data_channels)';
		ControlParadigm.Outputs = 0*data.voltage;
		ControlParadigm.Name = 'dummy';
		
	end

	OutputChannelNames = {'trigger'};
	SamplingRate = options.sampling_rate;
	save(strrep(file_name,'.abf','.mat'),'data','SamplingRate','ControlParadigm','OutputChannelNames');
end	