% generates a spiketrain with defined statistics
function spiketimes = spiketrain(varargin)

options.firing_rate = 10; % Hz
options.burst_period = NaN;
options.duty_cycle = NaN;
options.spike_jitter = 3e-3; % s
options.t_end = 10; % s 

options = corelib.parseNameValueArguments(options, varargin{:});

if isnan(options.burst_period) & isnan(options.duty_cycle)
	% tonically spiking neuron
	S = 1e3./options.firing_rate;
	spiketimes = 1:S:options.t_end*1e3;

	if options.spike_jitter == 0
		return
	end

	

else
	% bursting neuron
	keyboard
end