% tests functions in axlib
function test()

% axlib.equalize

figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on

ax(1) = subplot(1,2,1);
plot(1.1*rand(100,1)+.3,2*rand(100,1)+.2,'k.');

ax(2) = subplot(1,2,2);
plot(1.1*rand(100,1)+.1,2*rand(100,1)-.1,'k.');

axlib.equalize()
assert(all(ax(1).XLim == ax(2).XLim),'axlib.equalize broken')

drawnow
pause(1)

close all

figure('outerposition',[300 300 600 600],'PaperUnits','points','PaperSize',[1200 600]); hold on

plot(1.1*rand(100,1)+.3,2*rand(100,1)+.2,'k.');
figlib.pretty()
axlib.separate;

drawnow
pause(1)

close all