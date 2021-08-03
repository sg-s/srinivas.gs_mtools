% spiketimes2f 
% converts a list of spikes into a firing rate 
% vector using an Alpha function
% we expect spiketimes to be a sparse vector
% with 1 representing spike and 0 representing no spike


function FiringRate = spiketimes2f(spiketimes, options)


arguments
	spiketimes (:,1) double 
	options.InputTimeStep (1,1) double  % s
	options.OutputTimeStep (1,1) double = 1e-3 % s
	options.KernelSize (1,1) =  30e-3 % s
	options.InputTime (:,1) double
end



if isfield(options,'InputTime')

	% input time is defined, so use it, and make sure 
	% it is the right size

	assert(corelib.isSameSize(spiketimes,options.InputTime),'Expected spiketimes and the InputTime to be vectors of the same length')
else
	options.InputTime = (1:length(spiketimes))*options.InputTimeStep;

end



KernelTime = options.InputTimeStep:options.InputTimeStep:(options.KernelSize*10);


A = 1/options.KernelSize;
K = ((A^2)*exp(-A*KernelTime).*KernelTime);
% K = K/max(K);

% clip kernel
z = find(K>max(K)/100,1,'last');
K = K(1:z);
K = K(:);


FiringRate = full(0*spiketimes);
spike_locs = find(spiketimes);


for j = 1:length(spike_locs)
	a = spike_locs(j);
	z = a + length(K) - 1;

	if z > length(FiringRate)
		break
	end
	

	FiringRate(a:z) = FiringRate(a:z) + K;

end

OutputTime = options.OutputTimeStep:options.OutputTimeStep:options.InputTime(end);


FiringRate = interp1(options.InputTime(:),FiringRate,OutputTime(:));


