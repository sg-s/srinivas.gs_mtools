% makes a ridge plot
% from a matrix Y
% you can optionally supply a X vector X

function ridge(Y, X, options)

arguments
	Y (:,:) double 
	X (:,1) double  = 1:size(Y,2)
	options.Height = 2
	options.ColorMap = parula(100)
	options.ColorKey = 1:size(X,1)
	options.ax (1,1) matlab.graphics.axis.Axes = matlab.graphics.axis.Axes
	options.Filled = false
end


assert(ismatrix(X),'X must be a matrix')


if isempty(options.ax.Parent)
	figure('outerposition',[300 300 600 901],'PaperUnits','points','PaperSize',[600 901]); hold on

	options.ax = gca;
end

N = size(Y,1);

warning('off','MATLAB:polyshape:repairedBySimplify')

for i = 1:N


	D = Y(i,:)*options.Height;

	if all(isnan(D))
		continue
	end

	D = D(:);
	

	C = options.ColorMap(options.ColorKey(i),:);

	if options.Filled
		p = polyshape(X,-D+i);
		h = plot(options.ax,p);

		h.EdgeAlpha = .1;
		h.FaceColor = C;
		h.FaceAlpha = 1;

	else
		plot(X,i-D,'Color',C)
	end



end

% plot(all_medians(options.SamplePoints),-options.Height+options.SamplePoints,'Color',[.5 .5 .5])

warning('on','MATLAB:polyshape:repairedBySimplify')


set(options.ax,'XLim',[X(1) X(end)],'YDir','reverse')

