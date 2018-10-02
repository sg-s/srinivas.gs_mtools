% class that helps you find a border 
% given some objective function 

classdef thread < handle


properties



end % props


methods 




end % methods


methods (Static)


	function X = normalize(x,islog)
		X = x;
		if islog
			X = log(X) - log(min(x));
			X = X/(log(max(x)) - log(min(x)));
		else
			X = X - min(x);
			X = X/(max(x) - min(x));
		end
	end

	function [x,y] = unravel(x,y, log_x, log_y)

		if nargin < 3
			log_x = false;
		end
		if nargin < 4
			log_y = false;
		end

		% transform x and y
		X = thread.normalize(x,log_x);
		Y = thread.normalize(y,log_y);


		D = squareform(pdist([X(:) Y(:)]));





		all_wiring_cost = NaN(length(x),1);

		% check if there are any corners 
		edge_x = X == 1 | X == 0;
		edge_y = Y == 1 | Y == 0;
		corners = find(edge_x & edge_y);
		corners = [];
		if isempty(corners)

			for j = 1:length(all_wiring_cost)


				sort_idx = NaN(length(x),1);
				%[~,sort_idx(1)]=max(sum(D));
				sort_idx(1) = j;

				for i = 1:(length(x))-1

					other_nodes = setdiff(1:length(x),nonnans(sort_idx));
					other_dist = D(other_nodes,sort_idx(i));
					[~,closest_node] = min(other_dist);
					sort_idx(i+1) = other_nodes(closest_node);


				end

				sx = x(sort_idx);
				sy = y(sort_idx);

				% find all pairwise distances
				d = NaN*y;
				for i = 1:length(d)-1
					d(i) = sqrt((sx(i) - sx(i+1))^2 + (sy(i) - sy(i+1))^2);
				end

				all_wiring_cost(j) = nansum(d);

			end

			[~,start_here] = min(all_wiring_cost);


			sort_idx = NaN(length(x),1);
			sort_idx(1) = start_here;




		else
			% we have corners
			sort_idx = NaN(length(x),1);
			sort_idx(1) = corners(1);
		end



		for i = 1:(length(x))-1

			other_nodes = setdiff(1:length(x),nonnans(sort_idx));
			other_dist = D(other_nodes,sort_idx(i));
			[~,closest_node] = min(other_dist);
			sort_idx(i+1) = other_nodes(closest_node);

		end


		x = x(sort_idx);
		y = y(sort_idx);


		for i = 1:5
			[x,y] = thread.refine(x,y,log_x,log_y,i);
		end

		return

		[x,y] = thread.deintersect(x,y,log_x,log_y);

	end

	function [x,y] = deintersect(x,y,log_x,log_y)

		X = thread.normalize(x,log_x);
		Y = thread.normalize(y,log_y);

		keyboard

	end


	% in the refine step, we look at the longest edges
	% in the unravelled thread, and see if we can
	% break them to make the overall thread shorter
	function [x,y] = refine(x,y, log_x, log_y, N)

		X = thread.normalize(x,log_x);
		Y = thread.normalize(y,log_y);

		[L, segment_lengths] = thread.length(X,Y);

		% find the Nth biggest jump
		
		[~,sidx]=sort(segment_lengths,'descend');
		idx = sidx(N);
		a = idx;
		b = idx+1;

		% figure, hold on
		% plot(X,Y,'k.')
		% plot(X,Y,'r')

		% % show the segment
		% plot([X(a) X(b)],[Y(a) Y(b)],'b')

		% are both these nodes connected to their closest
		% neighbours? 
		D = squareform(pdist([X(:) Y(:)]));
		D(a,a) = Inf;
		D(b,b) = Inf;
		[~,closest_to_a] = min(D(:,a));
		[~,closest_to_b] = min(D(:,b));


		if closest_to_a == b | closest_to_a == a - 1 | closest_to_a == a + 1
			% ok
		else
			%disp('a is not connected to its closest neighbour')
			% REARRANGE nodes so that a is inserted after closest to a
			rest = setdiff((closest_to_a+1:length(x)),a);
			new_x = [x(1:closest_to_a); x(a); x(rest)];
			new_y = [y(1:closest_to_a); y(a); y(rest)];

			x = new_x;
			y = new_y;
			return
		end

		if closest_to_b == a | closest_to_b == b - 1 | closest_to_b == b + 1
			% ok
		else
			%disp('b is not connected to its closest neighbour')
			% REARRANGE nodes so that b is inserted after closest to b
			rest = setdiff((closest_to_b+1:length(x)),b);
			new_x = [x(1:closest_to_b); x(b); x(rest)];
			new_y = [y(1:closest_to_b); y(b); y(rest)];

			x = new_x;
			y = new_y;

		end





	end


	% computes the length of the thread
	function [L, segment_lengths] = length(x,y)
		segment_lengths = zeros(length(x)-1,1);
		for i = 1:length(x)-1
			segment_lengths(i) = ((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2);
		end
		segment_lengths = sqrt(segment_lengths);
		L = sum(segment_lengths);

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