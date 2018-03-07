function fig = plotPaperWindProfile()
% Function to create wind profile plot in paper
windData = evalin('base','windData');

fig = createFigure();

h.plot = plot(windData.NREL.time/60,windData.NREL.data);
grid on
h.ax = gca;

h.plot.LineWidth = 2;
h.plot.Color = 'k';
h.ax.FontSize = 40;

xlim([0 120])
xlabel('Time, t [min]')
ylabel('Wind Speed, [m$\cdot$s$^{-1}$]')
title('NREL Wind Profile')

% Eliminate the white space
set(h.ax,'LooseInset',get(gca,'TightInset'))
end