% plot a bar graph, with error bars, with a star
% on some bars
% 
% usage:
% plotlib.barWithErrorStar(X,Y,E,S)
% 
% all vectors are the same length
% S is a logical vector to determine if the star is plotted


function [bars, errors, stars] = barWithErrorStar(X,Y,E,S, options)

arguments
	X (:,1) double
	Y (:,1) double
	E (:,1) double
	S (:,1) logical
	options.Color = 'k'
	options.offset = .1
	options.LineWidth = 2
	options.ax (1,1) matlab.graphics.axis.Axes = gca
end

assert(length(X) == length(Y),'X and Y should be of equal length')
assert(length(X) == length(E),'X and E should be of equal length')
assert(length(X) == length(S),'X and S should be of equal length')


neg_E = E;
pos_E = E;
neg_E(Y>0) = 0;
pos_E(Y<0) = 0;

errors = errorbar(options.ax, X,Y,neg_E,pos_E,'LineStyle','none','Color', options.Color,'LineWidth',options.LineWidth);
bars = bar(options.ax,X,Y);
bars.FaceColor = options.Color;
bars.EdgeColor = options.Color;

offset = mean(Y+E)*options.offset;

stars = plot(options.ax, X(S),Y(S)+E(S)+offset,'*','LineStyle','none','Color',options.Color,'MarkerSize',10,'LineWidth',options.LineWidth);