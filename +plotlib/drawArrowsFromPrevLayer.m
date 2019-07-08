function feeder_nodes = drawArrowsFromPrevLayer(J, this_layer, this_node, n_layers, cutoff, Color, preW, feeder_nodes)

if ~exist('Color','var')
	Color = [.5 .5 .5];
end

if ~exist('preW','var')
	preW = 1;
end

if ~exist('feeder_nodes','var')
	feeder_nodes = [];
end

if this_layer >= n_layers
	return
end

prev_nodes = J(:,this_node);
prev_nodes = prev_nodes/sum(prev_nodes);

if this_layer > 0
	% only keep the top 2
	[~,idx] = sort(prev_nodes,'descend');
	prev_nodes(idx(3:end)) = 0;

end

W = prev_nodes(prev_nodes > cutoff);
prev_nodes = find(prev_nodes > cutoff);


max_width = 20;
min_width = 3;
steepnees = 25;
opacity = .35;


c = [lines(7); 1 0 0; 0 0 0; 1 0 .7843];

% draw lines to each of these previous nodes
for i = 1:length(prev_nodes)


	xx = linspace(-this_layer-1, -this_layer, 100);
	XX = xx - mean(xx); XX = XX*steepnees;
	yy = 1./(1 + exp(-XX));

	yy = yy*(this_node - prev_nodes(i));
	yy = yy + prev_nodes(i);

	% go back in layers
	if this_layer == 0
		Color = c(prev_nodes(i),:);
		preW = W(i);
	end

	ph = plot(xx, yy, 'Color', Color);
	ph.LineWidth = W(i)*(max_width-min_width)*preW + min_width;
	ph.Color = [Color opacity];


	if this_layer == n_layers - 1
		feeder_nodes = [feeder_nodes; prev_nodes(i)];
	end
	
	feeder_nodes = plotlib.drawArrowsFromPrevLayer(J, this_layer+1, prev_nodes(i), n_layers, cutoff, Color, preW, feeder_nodes);

end

