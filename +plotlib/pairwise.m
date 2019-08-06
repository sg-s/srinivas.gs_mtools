% plotlib.pairwise is a wrapper for plotmatrix
% and makes it much prettier, and allows for 
% labels on the x and y axes 
%
% usage:
% 
% plotlib.pairwise(X, labels)

function pairwise(X, labels, varargin)



options.Symmetric = true; % if true, top-right of matrix if not plotted
options.MarkerFaceColor = 'k';
options.MarkerEdgeColor = 'k';
options.HistLineAlpha = 0; 
options.Marker = '.';
options.NumBins = 10;
options.MarkerSize = 10;



assert(isnumeric(X),'X must be a numeric matrix')
assert(~isvector(X),'X should not be a vector')
assert(isvector(labels),'labels must be a cell array')
assert(iscell(labels),'labels must be a cell array')




assert(size(X,2) == length(labels),'The size of X and labels do not match')
labels = labels(:);



options = corelib.parseNameValueArguments(options, varargin{:});


[S, a, bigAx, h] = plotmatrix(X);

for i = 1:length(h)
	h(i).NumBins = options.NumBins;
end

if options.Symmetric
	for i = 1:length(labels)-1
		for j = i+1:length(labels)
			delete(a(i,j))
		end
	end
end



for i = 2:length(labels)
	ylabel(a(i,1),labels{i})
end

for i = 1:length(labels)
	xlabel(a(length(labels),i),labels{i})
end


for i = 1:size(S,1)
	for j = 1:size(S,2)
		if ~isvalid(S(i,j))
			continue
		end
		S(i,j).MarkerSize = options.MarkerSize;
		S(i,j).MarkerFaceColor = options.MarkerFaceColor;
		S(i,j).MarkerEdgeColor = options.MarkerEdgeColor;
		S(i,j).Marker = options.Marker;
	end
end

return

bigAx.XLim = [0 length(labels)];
bigAx.YLim = [0 length(labels)];
bigAx.Visible = 'on';
bigAx.XTick = .5:1:length(labels);
bigAx.YTick = .5:1:length(labels);
bigAx.YTickLabelRotation = 90;
bigAx.XTickLabel = labels;
bigAx.YTickLabel = flipud(labels);

old_position = bigAx.Position;
x_offset = old_position(3)*.05;
y_offset = old_position(4)*.05;

bigAx.Position = [old_position(1) - x_offset, old_position(2) - y_offset, old_position(3) + x_offset, old_position(4) + y_offset];


keyboard