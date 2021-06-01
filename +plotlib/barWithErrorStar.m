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
end

errors = errorbar(X,Y,E,'LineStyle','none','Color', options.Color);
bars = bar(X,Y);
bars.FaceColor = options.Color;
bars.EdgeColor = options.Color;

offset = mean(Y+E)*options.offset;

stars = plot(X(S),Y(S)+E(S)+offset,'*','LineStyle','none','Color',options.Color,'MarkerSize',10);