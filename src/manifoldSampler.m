classdef manifoldSampler



properties

	AttractionRadius (1,1) double {mustBePositive(AttractionRadius)} = 1
	RepulsionRadius (1,1) double {mustBePositive(RepulsionRadius)} = 2
	NPointsPerIter (1,1) double {mustBeInteger(NPointsPerIter)} = 8

	SampleFcn (1,1) function_handle = @() 0

end % props



methods


	function fit()

	end



end % methods



end % class