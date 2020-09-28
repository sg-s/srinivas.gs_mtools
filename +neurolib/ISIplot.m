% plots spiketimes vs. isis
function h = ISIplot(spiketimes)

isis = [NaN; diff(spiketimes)];

h = plot(spiketimes,isis,'.');