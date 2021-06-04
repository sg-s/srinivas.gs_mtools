% plots a sankey-diagram like plot
% showing transition states b/w nodes in a matrix

function feeder_nodes = sankeyMatrix(J, end_here, n_layers, cutoff, colors)


set(gca,'XLim',[-n_layers - 1, 1],'YLim',[0 length(J)+1]);


% draw lines to indicate prev states
for i = 1:n_layers
    plotlib.vertline(-i,'LineWidth',1,'Color',[.5 .5 .5]);
end

feeder_nodes = unique(plotlib.drawArrowsFromPrevLayer(J, 0, end_here, n_layers, cutoff, colors));







