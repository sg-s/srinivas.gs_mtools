classdef alluvial < ConstructableHandle


properties

	J double
	EndHere (1,1) double = NaN
	StartHere (1,1) double = NaN
	colors (1,1) dictionary 
	NLayers (1,1) double = 3

end


properties (SetAccess = private)
	feeder_nodes = []
end




methods


	function self = alluvial(varargin)
		self = self@ConstructableHandle(varargin{:});  

	end % constructor


	function feeder_nodes = plot(self)


		% draw lines to indicate prev states
		set(gca,'XLim',[-self.NLayers-.5 1],'YLim',[0 size(self.J,1)+1])
		for i = 1:self.NLayers
		    plotlib.vertline(-i,'LineWidth',1,'Color',[.5 .5 .5]);
		end
		


		prev_layer = self.J(:,self.EndHere);
		prev_layer = prev_layer/sum(prev_layer);


		 self.plotFlow(self.EndHere, prev_layer,0);
		 feeder_nodes = self.feeder_nodes;


	end % plot


	% creates patch objects indicating flow from layer to layer
	function  plotFlow(self,sink_node,prev_layer, layer_idx, Color)


		if all(isnan(prev_layer))
			return
		end
		

		Compress = .8;
		prev_layer = prev_layer*Compress;

		if layer_idx >= self.NLayers
			return
		end

		if nargin < 5
			Color = [];
		else
			% only show top two incoming nodes
			[~,sidx]=sort(prev_layer,'descend');
			prev_layer(prev_layer<prev_layer(sidx(2))) = 0;
		end

		if layer_idx == self.NLayers - 1
			self.feeder_nodes = unique([self.feeder_nodes; find(prev_layer)]);
		end

		steepnees = 25;
		keys = self.colors.keys;


		yoffset = 0;

		for j = 1:length(prev_layer)
			if prev_layer(j) == 0
				continue
			end

			% start making the polygon
			left_bottom.x = -layer_idx - 1;
			left_bottom.y = j;

			right_bottom.x = -layer_idx;
			right_bottom.y = sink_node;

			xx = linspace(left_bottom.x,right_bottom.x,100);
			XX = xx - mean(xx); XX = XX*steepnees;
			yy = 1./(1 + exp(-XX));

			yy = yy*(sink_node + yoffset - j);
			yy = yy + j;
			D = [0 diff(yy)];

			xx = [xx fliplr(xx)];
			if j > sink_node
				yy = [yy fliplr(-pi/2*D + yy + prev_layer(j))];
			else
				yy = [yy fliplr(pi/2*D + yy + prev_layer(j))];
			end

			if isempty(Color)
				p(j) = patch(xx,yy,self.colors(keys{j}));
				p(j).EdgeColor = 'w';
			else
				p(j) = patch(xx,yy,Color);
				p(j).EdgeColor = 'w';
			end
			p(j).FaceAlpha = .5;
			p(j).EdgeAlpha = 1;
			p(j).LineWidth = 1;

			yoffset = yoffset + prev_layer(j);
		

		end

	


		layer_idx = layer_idx  + 1;

		% go back one layer for each of the nodes
		for j = 1:length(prev_layer)
			if prev_layer(j) == 0
				continue
			end


			preceding_layer = self.J(:,j);
			preceding_layer = preceding_layer/sum(preceding_layer);


			if isempty(Color)
				self.plotFlow(j,preceding_layer,layer_idx, self.colors(keys{j}));
			else
				self.plotFlow(j,preceding_layer,layer_idx, Color);
			end
		end


		


	end % plotFlow


end % methods




end % classdef 