% barfit(A,b)
% Finds x which minimizes |Ax - b|_1 (ie. 1-norm of the residuals) using the Barrowdale/Roberts algorithm (Comm.of the ACM June 1974)
% 
%
% Last row and col of tableau store indices so we can extract sol’n when done
% m = number of equations, n = number of unknowns (m >= n) 
%
% this was obtained from Frank van Bussel's PhD thesis:
% http://ediss.uni-goettingen.de/bitstream/handle/11858/00-1735-0000-0006-B5BF-1/van_bussel.pdf?sequence=1
function x = barfit(A, b)

[m n] = size(A);
AA = [A b n+[1:m]’; [zeros(1,n); [1:n]] zeros(2,2)];
tmp = find(b<0);
AA(tmp,:) = -AA(tmp,:); % normalize so that all vals in b col are +ve AA(m+1,1:n) = sum(AA(1:m,1:n)); % marginal costs

stage = 1; % If A is not full rank useless columns are swapped to the 
start = 1; % front and start variable is incremented
indep = 0; % number of independent basis vectors
x = zeros(n,1); % solution vector

while stage < 3
	% determine entering vector. 
	% Stage 1: if last row element is > n col is slack which has already been swapped out of the basis. Of available cols choose the one with the largest marginal cost (abs because cost goes both ways when you are trying to minimize L1 norm). 
	% In stage 2 we are no longer swapping vectors into the basis etc, so we don’t need
	% to pre-filter this way.
	if stage == 1
		t1 = find(abs(AA(m+2,start:n)) <= n); 
		[mx id] = max(abs(AA(m+1,t1)));
		p_in = t1(id) + start - 1;
	else % stage == 2
		[mx xid] = max(AA(m+1,start:n)); 
		[mn nid] = min(AA(m+1,start:n)); 
		if start > n
			stage = 3;
			break;
		elseif mx >= -mn - 2 && mx > eps
			p_in = xid + start - 1; 
		elseif -mn - 2 > eps
			p_in = nid + start - 1;
		else % no decent marginal costs left...
			stage = 3;
			break; 
		end
	end

	if AA(m+1,p_in) < 0 
		AA(:,p_in) = -AA(:,p_in); 
		if stage == 2
			AA(m+1,p_in) = AA(m+1,p_in) - 2;
			% Note: this -2 fiddling is how B&R avoid the necessity of having 2 constraints for every residual...
		end
	end

	% determine leaving vector
	t1 = find(AA(indep+1:m,p_in) > eps) + indep;
	chk = AA(t1,n+1) ./ AA(t1, p_in); % ratio of bound to potential pivots 

	while ~isempty(chk)
		[mn id] = min(chk);
		if mn == 0
		% If there are 0’s in b col then there is possibility of cycling because of degeneracy; idea here is to use magnitude of AA vals as tie breakers to avoid that (seems to work well in practise, but I % have no rigorous proof etc). When mn is not 0 we can depend on numerical errors to perturb the system enough to nudge it out of cyclic behaviour (don’t freak, this is what the pros do).
			id2 = find(chk == 0);
			[mn id3] = max(abs(AA(t1(id2),p_in))); 
			id = id2(id3);
		end

		p_out = t1(id);
		pivot = AA(p_out, p_in);
		if AA(m+1,p_in) - 2*pivot <= eps;
			break % values close enough to pivot, so do it... 
		else
			% o.w. we reduce marginal costs across the board and check another pivot. This while loop should only do O(m) iterations the first % couple of times, after which the marg.costs should be in spitting % distance of the A matrix values...
			AA(m+1,start:n+1) = AA(m+1,start:n+1) - 2.*AA(p_out,start:n+1);
			AA(p_out,start:n+2) = -AA(p_out,start:n+2);
			chk(id) = [];
			t1(id) = [];
		end
	end

	if isempty(chk) 
		% most likely because nothing was found in the 1st place. column is useless, but we still have others to try, so swap it out of the working space 
		if stage == 1  
			AA(:, [start, p_in]) = AA(:, [p_in, start]);
			start = start + 1; 
			if indep + start > n
				stage = 2; 
			end
        	continue;
    	else % stage = 2
			disp('CALCULATION TERMINATED PREMATURELY DUE TO ROUNDING ERRORS.');
			x = [];
			return;
		end
	end

	% pivot on p_in, p_out
	t_out = AA(p_out,start:n+1)./pivot;
	t_out(p_in-start+1) = 1+1/pivot;
	t_in = AA(1:m+1, p_in);
	t_in(p_out) = pivot - 1;
	AA(1:m+1,start:n+1) = AA(1:m+1,start:n+1) - t_in*t_out;

	% this should have the effect of setting pivot -> 1/pivot, a in pivot row -? a/pivot, a in pivot col -> -a/pivot

	t = AA(p_out, n+2); % swap index vals in last row, col of pivot
	AA(p_out, n+2) = AA(m+2, p_in);
	AA(m+2, p_in) = t;
	if stage == 1 % move new basis vector to top of the tableau
		indep = indep + 1;
		AA([indep p_out],start:n+2) = AA([p_out indep],start:n+2); 
		if indep + start > n
			stage = 2; 
		end
	end
end
% extract solution from tableau (in indep rows of b col, not necessarily in  any kind of order...)
t = AA(1:indep,n+2);
x(abs(t)) = AA(1:indep,n+1) .* sign(t);





