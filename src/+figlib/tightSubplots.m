% useful wrapper to subplot
% that makes tightly spaced axes 
% for use lots of plots that share a common
% X or Y axes

function [ax, left_edge, bottom_edge] =  tightSubplots(n_rows, n_cols, args)

arguments
	n_rows (1,1) double = 2
	n_cols (1,1) double = 2
	args.ShareX (1,1) logical = true
	args.ShareY (1,1) logical = true
	args.MarginX (1,1) double = .05
	args.MarginY (1,1) double = .05
	args.padding (1,1) double = .05
end

n_axes = n_rows*n_cols;

for i = n_axes:-1:1
	ax(i) = subplot(n_rows,n_cols,i);
	hold on
end

drawnow

hspacing = (1 - args.MarginX)/n_cols;

for i = 1:n_axes
	ax(i).Position(1) = rem(i-1,n_cols)*hspacing;
	ax(i).Position(3) = hspacing - args.padding;
end


vspacing = (1- args.MarginY)/n_rows;

for i = 1:n_axes
	row = floor((i-1)/n_cols) + 1;
	ax(i).Position(2) = 1 - row*vspacing;
	ax(i).Position(4) = vspacing - args.padding;
end





if args.ShareX
	for i = 1:length(ax)
		% yes, this is correct
		[~,row] = ind2sub([n_cols,n_rows],i);

		if row < n_rows
			ax(i).XTickLabel = [];
		end
	end
end


if args.ShareY
	for i = 1:length(ax)
		% yes, this is correct
		[col,~] = ind2sub([n_cols,n_rows],i);

		if col > 1
			ax(i).YTickLabel = [];
		end
	end
end


if args.ShareY && args.ShareX
	linkaxes(ax)
elseif args.ShareY
	linkaxes(ax,'y')
elseif args.ShareX
	linkaxes(ax,'x')
end



% figure out the left edge
left_edge = ax(rem(1:length(ax),n_cols) == 1);


% figure out the bottom edge
bottom_edge = ax((1:length(ax)) - n_cols > 0);