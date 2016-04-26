% STA.m
% computes the spike triggered averaged stimulus.
% works with one or many trials
% minimal usage:
% K = STA(spikes,stimulus)
% 
% full usage:
% K = STA(spikes,stimulus,'normalise',true,'regulariseParameter',1,'before',100,'after',10);
% 
% created by Srinivas Gorur-Shandilya at 3:48 , 18 March 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function K = STA(spikes,stimulus,varargin)

% defaults
before = 5e2;
after = 0;
regulariseParameter = NaN;
normalise = true;

if ~nargin
    help STA
    return
else
    if iseven(nargin)
    	for ii = 1:2:length(varargin)-1
        	temp = varargin{ii};
        	if ischar(temp)
            	eval(strcat(temp,'=varargin{ii+1};'));
        	end
    	end
	else
    	error('Inputs need to be name value pairs')
	end
end

% defensive programming
assert(issparse(spikes),'First argument should be a sparse matrix')
assert(length(spikes) == length(stimulus),'first two arguments have to be the same length')

% orient matrices properly
if ~isvector(spikes)
	if size(spikes,2) > size(spikes,1)
		spikes = spikes';
	end
	
else
	spikes = spikes(:);
end
if ~isvector(stimulus)
	if size(stimulus,2) > size(stimulus,1)
		stimulus = stimulus';
	end
else
	stimulus = stimulus(:);
end

K = zeros(before+after+1,width(spikes));


for i = 1:width(spikes)
	% normalise if needed
	if normalise
		stimulus(:,i) =  stimulus(:,i) - mean(stimulus(:,i));
		stimulus(:,i) =  stimulus(:,i)/std(stimulus(:,i));
	end
	permitted_spikes = find(spikes(:,i));
	permitted_spikes(permitted_spikes<before) = [];
	permitted_spikes(permitted_spikes>length(stimulus)-after) = [];

	Y = zeros(length(permitted_spikes),before+after+1);
	
	for j = 1:length(permitted_spikes)
		this_spike = permitted_spikes(j);
		Y(j,:) = stimulus(this_spike-before:this_spike+after,i);		
	end

	if ~isnan(regulariseParameter)
		all_times = before+1:length(stimulus)-after-1;
		X = zeros(length(all_times),size(K,1));
		for j = 1:length(all_times)
			this_spike = all_times(j);
			X(j,:) = stimulus(this_spike-before:this_spike+after,i);		
		end

		C = X'*X; 

		MeanEigenValue = trace(C)/length(C);

		C2 = C + eye(length(C))*MeanEigenValue*regulariseParameter;

		K(:,i) = mean(inv(C2)*Y',2);

		% K(:,i) = (mean(((C + regulariseParameter*MeanEigenValue*eye(length(C)))\Y')')); 

		K(:,i) = K(:,i)/max(K(:,i));
		K(:,i) = K(:,i)*max(mean(Y,1));
	else

		K(:,i) = mean(Y,1);
	end



end

K = flipud(K);




