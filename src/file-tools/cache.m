% cache.m
%
% usage:
% 


function varargout = cache(hash, varargin)


if nargin == 0 
	help cache
	return
end

% check for file 
d = dbstack;
if length(d) == 1
	look_here = pwd;
else
	look_here = fileparts(which(d(2).name));
end

if nargin == 1
	% we are reading from the cache


	if exist([look_here filesep '.cache']) == 7
		% .cache exists

		if exist([look_here filesep '.cache' filesep hash '.mat']) == 2
			load([look_here filesep '.cache' filesep hash '.mat'])
			variables = whos('-file',[look_here filesep '.cache' filesep hash '.mat']);
			for i = 1:length(variables)
				eval(['varargout{i} = ' variables(i).name ';'])
			end
			return
		else
			varargout{1} = [];
			return
		end

	else
		varargout{1} = [];
		return
	end


end

if nargin > 1
	% store mode 


	v = {};
	for i = 1:length(varargin)
		eval([inputname(i+1) '=varargin{' mat2str(i) '};'])
		v{i} = inputname(i+1);
	end

	savefast([look_here filesep '.cache' filesep hash '.mat'],v{:})



end