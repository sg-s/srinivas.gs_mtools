function closeManualCluster(self,~,~)


% if all points are unassigned, just quit
if all(isundefined(self.idx))
	delete(self.handles.main_fig)
	return
end

undefined_pts = isundefined(self.idx);

% first make sure that there are no unassigned data points
if any(undefined_pts)

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

