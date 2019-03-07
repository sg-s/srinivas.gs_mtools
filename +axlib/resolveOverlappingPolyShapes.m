% resolves overlapping polyshapes so there is no overlap

function resolveOverlappingPolyShapes(ax)


if isempty(ax)
	ax = gca;
end

p = ax.Children;


for i = 1:length(p)
	for j = 1:length(p)
		if i == j
			continue
		end

		if ~isa(p(i),'matlab.graphics.primitive.Polygon')
			continue
		end

		if ~isa(p(j),'matlab.graphics.primitive.Polygon')
			continue
		end

		x = p(j).Shape.Vertices(:,1);
		y = p(j).Shape.Vertices(:,2);

		X = p(i).Shape.Vertices(:,1);
		Y = p(i).Shape.Vertices(:,2);

		if all(inpolygon(x,y,X,Y))
			% j is entirely contained within i
			new_shape = subtract(p(i).Shape,p(j).Shape);
			p(i).Shape = new_shape;
	
		end

	end
end

