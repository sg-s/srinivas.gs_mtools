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
% This key can be used like in a normal structure:
%
% colors.('light purple')
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
		

		if length(varargin) == 1
			% we are asking for a value using a key
			keyboard
		end

		% check that we are getting an even number of inputs
		assert(floor(length(varargin)/2)*2 == length(varargin),'Expected an even number of arguments')

		for i = 1:2:length(varargin)
			keyhash = ['h' hashlib.md5hash(varargin{i})];
			self.addprop(keyhash);
			self.(keyhash) = varargin{i+1};
			self.keys = [self.keys varargin{i}];
		end

	end


	function value = subsref(self,key)

		if strcmp(key.subs,'keys')
			value = self.keys;
			return
		end

		keyhash = ['h' hashlib.md5hash(key.subs)];
		if isprop(self,keyhash)
			value = self.(keyhash);
			return
		end
	end

	function self = subsasgn(self,key, value)



		keyhash = ['h' hashlib.md5hash(key.subs)];
		if ~isprop(self,keyhash)
			self.addprop(keyhash);
			self.keys = [self.keys key.subs];
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