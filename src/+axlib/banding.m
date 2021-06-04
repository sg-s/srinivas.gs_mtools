% makes a nice banding in some axes
% useful for presenting data as a table
% in a axes

function banding(options)

arguments
	options.ax (1,1) = gca
	options.foregroundColor (3,1)  = [.9 .9 .9]
	options.backgroundColor (3,1)  = [1 1 1]
	options.spacing (1,1) = 1
	options.start (1,1) = 0
end

ylim = options.ax.YLim;
xlim = options.ax.XLim;

for i = options.start:2*options.spacing:(ylim(2)-options.spacing)

	r = rectangle(options.ax,'Position',[xlim(1) i xlim(2) - xlim(1) options.spacing]);
	r.EdgeColor = options.foregroundColor;
	r.FaceColor = options.foregroundColor;

	uistack(r,'bottom');


	if i + 2*options.spacing < ylim(2)

		r = rectangle(options.ax,'Position',[xlim(1) i+options.spacing xlim(2) - xlim(1) options.spacing]);
		r.EdgeColor = options.backgroundColor;
		r.FaceColor = options.backgroundColor;

		uistack(r,'bottom');
	end

end

