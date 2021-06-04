% finds fixed points and measures stability in 1D ODE
% 
function [fps, stability] = findFixedPointsInODE(f, x_range, desired_n_fp)


fps = NaN(desired_n_fp,1);
stability = NaN(desired_n_fp,1);

% first find an approximate shape of the curve 
all_x = linspace(x_range(1),x_range(2),100);
fx = NaN*all_x;

for i = 1:length(all_x)
	fx(i) = f(all_x(i));
end

fp_loc = find(diff(fx>0));
if ~any(fp_loc)
	% no fixed points
	return
end

n_fixed_points = length(fp_loc);

fps = all_x(fp_loc);


F = @(x) abs(f(x));


deltax = diff(x_range)/1e3;


for i = 1:n_fixed_points
	if i > desired_n_fp
		return
	end

	% refine the coarse guess
	fps(i) = fminsearch(F,fps(i));

	stability(i) = f(fps(i)+deltax) - f(fps(i)-deltax) < 0;

end