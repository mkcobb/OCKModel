function h=plotSpatialILCPerformanceIndex()
tsc=evalin('base','tsc');

h.figure = createFigure();

h.ax1 = subplot(2,1,1);
plot(tsc.time,tsc.performanceIndex.data,...
    'DisplayName','Total','LineWidth',2)
hold on
for ii = 1:length(tsc.performanceIndexComponents.data(1,:))
   plot(tsc.time,tsc.performanceIndexComponents.data(:,ii),...
       'DisplayName',sprintf('Wypt %d Min Dist',ii),...
       'LineWidth',2) 
end
legend
grid on
set(gca,'FontSize',24)
xlabel('Time, [s]')
ylabel('[m]')
axis tight
title('Performance Index')
h.ax2 = subplot(2,1,2);
plot(tsc.performanceIndex.data(tsc.waypointUpdateTrigger.data),...
    'DisplayName','Total','LineWidth',2)
hold on
for ii = 1:length(tsc.performanceIndexComponents.data(1,:))
   plot(tsc.performanceIndexComponents.data(tsc.waypointUpdateTrigger.data,ii),...
       'DisplayName',sprintf('Wypt %d Min Dist',ii),...
       'LineWidth',2) 
end
legend
grid on
set(gca,'FontSize',24)
xlabel('Iteration Number')
ylabel('[m]')
axis tight

end