classdef (Abstract) model < handle 

properties


	Stimulus
	Parameters
	Response
	Prediction


	Lower
	Upper

	FitOptions = optimoptions('particleswarm');



end % props

properties (Access = protected)
	ParameterNames
	handles
end

methods


	function evaluate(self)
	end




	function fit(self)

		assert(~isempty(self.Upper),'Upper bounds must be set')
		assert(~isempty(self.Lower),'Lower bounds must be set')

		lb = structlib.vectorise(orderfields(self.Lower));
		ub = structlib.vectorise(orderfields(self.Upper));

		assert(length(lb) == length(ub),'Length of Upper and Lower bounds not the same')

		self.ParameterNames = sort(fieldnames(self.Upper));

		assert(length(ub) == length(self.ParameterNames),'Length of ParameterNames does not match bounds')

		if isempty(self.Parameters)
			% pick a random point within bounds
			x =  (ub-lb).*(rand(length(lb),1)) + lb;
			for i = 1:length(self.ParameterNames)
				self.Parameters.(self.ParameterNames{i}) = x(i);
			end
		end


		self.FitOptions.InitialSwarmMatrix = structlib.vectorise(self.Parameters)';

	

		x = particleswarm(@(x) self.fitEvaluate(x),length(self.FitOptions.InitialSwarmMatrix), lb,ub, self.FitOptions);

		for i = 1:length(self.ParameterNames)
			self.Parameters.(self.ParameterNames{i}) = x(i);
		end



	end % fit



	function C = fitEvaluate(self, x)
		for i = 1:length(self.ParameterNames)
			self.Parameters.(self.ParameterNames{i}) = x(i);
		end
		self.evaluate();
		C = self.cost();
	end


	function plot(self)

		if isfield(self.handles,'fig') && isvalid(self.handles.fig)
		else
			self.handles.fig = figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
			figlib.pretty()
		end

		if ~isempty(self.Response)
			if isfield(self.handles,'response') && isvalid(self.handles.response)
				self.handles.response.YData = self.Response;
			else
				self.handles.response = plot(self.Response,'k','LineWidth',2);
			end
		end

		self.evaluate;

		if isfield(self.handles,'prediction') && isvalid(self.handles.prediction)
			self.handles.prediction.YData = self.Prediction;
		else
			self.handles.prediction = plot(self.Prediction,'r','LineWidth',2);
		end




	end% plot



	function C = cost(self)

		C = nansum((self.Prediction - self.Response).^2);

	end



	function manipulate(self)



		% create a puppeteer instance and configure
		warning('off','MATLAB:hg:uicontrol:ValueMustBeInRange')
		warning('off','MATLAB:hg:uicontrol:MinMustBeLessThanMax')


		values = structlib.vectorise(self.Parameters);

		if isempty(self.Upper)
			ub = values*5;
		else
			ub = structlib.vectorise(self.Upper);
		end

		if isempty(self.Lower)
			lb = values/5;
		else
			lb = structlib.vectorise(self.Lower);
		end

		p = puppeteer(sort(fieldnames(self.Parameters)),values,lb,ub,[]);
		self.handles.puppeteer_object = p;

		self.plot;

		warning('on','MATLAB:hg:uicontrol:MinMustBeLessThanMax')
		warning('on','MATLAB:hg:uicontrol:ValueMustBeInRange')

		p.continuous_callback_function = @self.manipulateEvaluate;



	end


	function manipulateEvaluate(self, names, values)
		self.Parameters.(names{1}) = values;
		self.plot;
	end

end % methods



methods (Static)




end % static methods

end % classdef 