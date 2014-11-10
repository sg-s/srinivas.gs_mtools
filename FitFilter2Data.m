% [K] = FitFilter2Data(stim, response,filter_length,reg,n,OnlyThesePoints)
% fits a linear filter to data.
% based on Chichlinsky's STA method
% created by Srinivas Gorur-Shandilya at 16:04 , 15 January 2014. 
% Contact me at http://srinivas.gs/contact/
% 
% Usage: 
% 
% K = FitFilter2Data(stim, response);
% this is the minimal usage. you must specify stim and response, and they must be vectors of the same length.
% 
% Optional arguments 
% 
% filter_length:    how many points do you want K to have? scalar, default is 333
% reg:              regularisation factor. scalar, default is 1. makes filter ring less. reg is in 
% 					units of the mean of the eigenvalues of the covariance matrix. 
% n:                0 or 1. Do you want to subtract mean before computing filter? default is 0. 
% OnlyThesePoints:  vector that contains matrix coordinates of points in time that you want to 
%                   restrict filter computation on. max(OnlyThesePoints) must be < 
%                   length(stim)-filter_length
% regtype:			refer to code.
%
% Defaults:
% filter_length = 333;
% reg = 1; 
% n = 1;
% OnlyThesePoints = 1:length(stim)-filter_length; (everything)
% regtype = 2;
% 
% Example: 
% 
% K=FitFilter2Data(stim, response,[1:2000],'filter_length=500;','n=1;')
% 
% calculates a 500-point filter from the data after removing mean and regularising, but only at the first 2000 points of the data.
function [K, C] = FitFilter2Data(stim, response, OnlyThesePoints, varargin)
if ~nargin
	help FitFilter2Data
	return
end

% defaults
filter_length = 333;
reg = 1e-1; % in units of mean of eigenvalues of C
n = 1;
regtype = 2;

% evaluate optional inputs
for i = 1:nargin-3
	eval(varargin{i})
end




if nargin < 3
	OnlyThesePoints = filter_length+1:length(stim);
else
	if isempty(OnlyThesePoints)
		OnlyThesePoints = filter_length+1:length(stim);
	else
		% remove points that can't be computed
		OnlyThesePoints(OnlyThesePoints < filter_length+1) = [];
		
	end
end



% check that stimulus and response are OK

if isvector(stim) && isvector(response)
	% stimulus and response are both vectors, so do it the easy way

	% ensure column
	stim = stim(:);
	response = response(:);

	% check that there are no NaNs
	if any(isnan([stim;response]))
		error('NaN in inputs, cannot continue')
	end

	% check that there are no Infs
	if sum(isinf(stim)) || sum(isinf(response))
		error('Inf in inputs/outputs, cannot continue')
	end

	% subtract mean in response
	if n
		response = response - mean(response);
		stim = stim - mean(stim);
	end



	% throw away parts of the response for which we don't care
	response = response(OnlyThesePoints);

	% chop up the stimulus into blocks  
	s = zeros(length(OnlyThesePoints), filter_length+1);
	for i=1:length(OnlyThesePoints)
		s(i,:) = stim(OnlyThesePoints(i):-1:OnlyThesePoints(i)-filter_length);
	end

	% compute covariance matrix
	C = s'*s; % this is the covariance matrix, scaled by the size of the C
	% scale reg by mean of eigenvalues
	MeanEigenValue = trace(C)/length(C); % cheat; this is the same as mean(eig(C))
	reg = reg*MeanEigenValue;


	switch regtype 
		case 1
			C = C + reg*eye(filter_length+1); % Carlotta's reg.
		case 2
			C = (C + reg*eye(filter_length+1))*trace(C)/(trace(C) + reg*filter_length);
	end


	K = C\(s'*response);


else
	error('Stimulus or response is not a vector, cannot continue. Fitting multiple datasets? Use the OnlyThesePoints option. ')
	

end














        


