% snap position of axes in a figure to a grid

function snap(N)


all_ax = get(gcf,'Children');


if length(all_ax) == 0
	return
end

for i = 1:length(all_ax)
	all_ax(i).Position = round(all_ax(i).Position*N)/N;
	W = round(all_ax(i).Position(3)*100);
	H = round(all_ax(i).Position(4)*100);
	X = mean(all_ax(i).XLim);
	Y = mean(all_ax(i).YLim);
	text_handles(i) = text(all_ax(i),X,Y,[mat2str(W) 'x' mat2str(H)],'FontSize',24);
end

drawnow

pause(2)
for i = 1:length(all_ax)
	delete(text_handles(i))
end
