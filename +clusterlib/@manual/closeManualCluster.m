function closeManualCluster(self,~,~)


UNDF = categorical({'Undefined'});


undefined_pts = self.idx == UNDF;

% first make sure that there are no unassigned data points
if any(self.idx ~= UNDF)

	for i = 1:length(self.idx)
		 R2 = self.ReducedData;

		if undefined_pts(i)
			% this point needs to be assigned


			d = ((R2(i,1)-R2(:,1)).^2 + (R2(i,2)-R2(:,2)).^2);
			d(undefined_pts) = Inf;
			[~,loc] = min(d);

			self.idx(i) = self.idx(loc);

		end

	end

	self.redrawReducedDataPlot();
	drawnow;


end


delete(self.handles.main_fig)

