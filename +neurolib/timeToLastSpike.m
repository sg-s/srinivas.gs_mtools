% converts a list of spiketimes into a vector
% of time to last spike
% 
function T = timeToLastSpike(spiketimes, t_max, dt)


assert(isnumeric(spiketimes),'spiketimes must be a list of spiketimes')
assert(isvector(spiketimes),'spiketimes must be a vector of spiketimes')


spiketimes = spiketimes(:);
spiketimes = sort(spiketimes);

if nargin == 1
	t_max = spiketimes(end);
	dt = 1e-3;
elseif nargin == 2
	dt = 1e-3;
end

T = (dt:dt:t_max)*0;
T = T(:);

spiketimes = ceil(spiketimes/dt);

spiketimes(spiketimes == 0) = 1;
spiketimes(spiketimes > length(T)) = length(T);

for i = 2:length(spiketimes)
	T(spiketimes(i-1):spiketimes(i)-1) = linspace(0,spiketimes(i)-spiketimes(i-1),spiketimes(i)-spiketimes(i-1));
end