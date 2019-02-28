% voronoiSegment
% class that helps draw borders between
% regions in 2D space given some 
% function that returns discrete values
% when given an argument from the plane 
%
% usage:
% see voronoiSegment.test()

classdef voronoiSegment < handle


properties

	sim_func@function_handle
	x_range 
	y_range 
	n_seed@double

	x_scale = 'log'
	y_scale = 'log'


	x
	y
	R

	boundaries

	n_classes = 2


	labels@cell

	% stopping conditions
	min_mesh_size = 1e-6;
	max_fun_eval = 1e4;
	mean_mesh_size = 2e-5;

	make_plot = false;
	segment_regions = true;
	Display = 'iter'


	% you can use this to store anything you 
	% want. this will be sent to the function
	% 
	data

	% additional results returned by
	% objective function for post-hoc
	% analysis 
	results@Data
	handles


	% stores the triangulation
	DT@delaunayTriangulation

end % props




methods (Static)


	function [R, D] = test_linear(x,y,~)

		R = 1;
		D = Data;
		if x < .3
			return
		end
		if x > .6
			return
		end

		if y < x
			return
		end

		if y > x + .1
			return
		end

		R = 2;
		

	end

	function [R, D] = test_log(x,y,~)

		R = 1;
		D = Data;

		if y < 1e-2
			return
		end

		if x > .5 & x < 2
			return
		end

		if y > 1/x & x > .5
			R = 2;
			return
		end

		if y > x
			R = 3;
			return
		end

	end

end


end % end classdef