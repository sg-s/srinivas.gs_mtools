function h2 = duplicateFigure(h1)
switch nargin 
case 0
	help duplicateFigure
	return
end
h2=figure;
objects=allchild(h1);
copyobj(get(h1,'children'),h2);
set(gcf,'color',get(h1,'color'))
set(gcf,'position',get(h1,'position'))

