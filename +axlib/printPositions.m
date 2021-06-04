% generates code for axis positions
% so that axes can be precisely positioned 
% programmatically 

function printPositions(ax, postfix)

arguments
	ax
	postfix = ''
end

if isstruct(ax)
	fn = fieldnames(ax);
	for i = 1:length(fn)
		axlib.printPositions(ax.(fn{i}),fn{i})
	end
	return
end

assert(isa(ax,'matlab.graphics.axis.Axes'),'Expected an axes')


if numel(ax) > 1
	for i = 1:numel(ax)
		postfix = ['('  mat2str(i) ')'];
		axlib.printPositions(ax(i),postfix)
	end
	return
end

disp([postfix '.Position = ' mat2str(ax.Position,2) ';' ]);