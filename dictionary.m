% a dictionary class in MATLAB
% a key-value store
% keys can be anything, including strings that are illegal in MATLAB
%
% Example usage:
% 
% colors = dictionary('light purple',[.2 .3 .4])
% creates a dictionary with one key called 'light purple'
% Note the space in the key
%
% This key can be used to retrieve the value:
%
% colors('light purple')
%
% View all keys in the dictionary:
% 
% colors.keys

classdef  dictionary  < dynamicprops & matlab.mixin.CustomDisplay


properties (SetAccess = private)
	keys cell 
end



methods

	function self =  dictionary(varargin)
		if length(varargin) == 0
			return
		end
	

		% check that we are getting an even number of inputs
		assert(floor(length(varargin)/2)*2 == length(varargin),'Expected an even number of arguments')

		for i = 1:2:length(varargin)
			key = varargin{i};
			if iscategorical(key)
				key = char(key);
			end
			keyhash = ['h' hashlib.md5hash(key)];
			self.addprop(keyhash);
			self.(keyhash) = varargin{i+1};
			self.keys = [self.keys; varargin{i}];
		end

	end


	function value = subsref(self,key)

		if iscell(key.subs)
			key.subs = key.subs{1};
		end

		if strcmp(key.subs,'keys')
			value = self.keys;
			return
		end

		if iscategorical(key.subs)
			key.subs = char(key.subs);
		end

		keyhash = ['h' hashlib.md5hash(key.subs)];
		if isprop(self,keyhash)
			value = self.(keyhash);
			return
		end
	end

	function self = subsasgn(self,key, value)

		if iscategorical(key.subs)
			key.subs = char(key.subs);
		end

		keyhash = ['h' hashlib.md5hash(key.subs)];
		if ~isprop(self,keyhash)
			self.addprop(keyhash);
			self.keys = [self.keys; key.subs];
		end
		self.(keyhash) = value;
	end



end % end methods


methods (Access = protected)

	function displayScalarObject(self)

		disp('Dictionary object with keys:')
		for i = 1:length(self.keys)
			disp(self.keys{i})
		end


	end

end


end % classdef 