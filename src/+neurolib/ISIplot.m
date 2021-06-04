% makes a plot of spiketimes vs. ISIs
% 
function h = ISIplot(spiketimes)

spiketimes = spiketimes(:);
isis = [NaN; diff(spiketimes)];
h = plot(spiketimes,isis,'.');