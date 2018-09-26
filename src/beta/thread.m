% class that helps you find a border 
% given some objective function 

classdef thread < handle


properties



end % props


methods 




end % methods


methods (Static)


	function [x,y] = unravel(x,y)

		D = squareform(pdist([x(:) y(:)]));


		sort_idx = NaN(length(x),1);
		[~,sort_idx(1)]=max(sum(D));

		

		for i = 1:(length(x))-1

			other_nodes = setdiff(1:length(x),nonnans(sort_idx));
			other_dist = D(other_nodes,sort_idx(i));
			[~,closest_node] = min(other_dist);
			sort_idx(i+1) = other_nodes(closest_node);


		end

		x = x(sort_idx);
		y = y(sort_idx);

	end

	function test()

		x = shuffle(linspace(-pi,pi,20));
		y = sin(x);

		figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on
		subplot(1,2,1); hold on
		plot(x,y,'k.')
		plot(x,y,'r-')

		subplot(1,2,2); hold on
		plot(x,y,'k.')

		[x,y] = thread.unravel(x,y);
		plot(x,y,'r-')

	end


end


end % end classdef