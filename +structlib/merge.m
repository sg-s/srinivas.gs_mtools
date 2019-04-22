% merge two scalar structures, come what may
function S = merge(X,Y)

assert(isstruct(X),'X must be a structure')
assert(isstruct(Y),'Y must be a structure')


fnX = fieldnames(X);
fnY = fieldnames(Y);
fn = [fnX; fnY];


nX = length(X);
if length(fnX) == 0
	nX = 0;
end


nY = length(Y);
if length(fnY) == 0
	nY = 0;
end

S = repmat(struct,nX+nY,1);

idx = 1;

if nX > 0
	for i = 1:length(X)
		for j = 1:length(fn)
			if  any(strcmp(fnX,fn{j}))
				S(idx).(fn{j}) = X(i).(fn{j});
			end
		end
		idx = idx + 1;
	end
end

if nY > 0
	for i = 1:length(Y)
		for j = 1:length(fn)
			if  any(strcmp(fnY,fn{j}))
				S(idx).(fn{j}) = Y(i).(fn{j});
			end
		end
		idx = idx + 1;
	end
end