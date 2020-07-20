% makes new axes for insets
function ax = inset(MainPlots)

assert(isa(MainPlots,'matlab.graphics.axis.Axes'),'Expected argument to be axes handles')

for i = length(MainPlots):-1:1

	position = MainPlots(i).Position;
	ax(i) = axes;
	ax(i).Position(1)= position(1) + position(3)*.75;
	ax(i).Position(2)= position(2) + position(4)*.75;
	ax(i).Position(3)= position(3)/3;
	ax(i).Position(4)= position(4)/3;
end
