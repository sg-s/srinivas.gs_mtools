% useful wrapper to subplot
% that makes tightly spaced axes 
% for use in showing images

function ax = imageSubplots(n_rows, n_cols)

figure('outerposition',[300 300 801 1001],'PaperUnits','points','PaperSize',[801 1001]); hold on

n_axes = n_rows*n_cols;

for i = n_axes:-1:1
	ax(i) = subplot(n_rows,n_cols,i);
	hold on
	axis image
	ax(i).XTick = [];
	ax(i).YTick = [];
	text(ax(i),.5,.5,mat2str(i))

end

drawnow

hspacing = 1/n_cols;

for i = 1:n_axes
	ax(i).Position(1) = rem(i-1,n_cols)*hspacing;
	ax(i).Position(3) = hspacing;
end


vspacing = 1/n_rows;

for i = 1:n_axes
	row = floor((i-1)/n_cols) + 1;
	ax(i).Position(2) = 1 - row*vspacing;
	ax(i).Position(4) = vspacing;
end
