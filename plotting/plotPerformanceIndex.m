function h = plotPerformanceIndex()
iter = evalin('base','iter');

h.figure = createFigure();

h.axSpatialError = subplot(3,1,1);
plot(iter.spatialError);
grid on
xlabel('Iteration Number')
ylabel('Spatial Error')
set(gca,'FontSize',24)

h.axMeanPAR = subplot(3,1,2);
plot(iter.meanPAR);
grid on
xlabel('Iteration Number')
ylabel('Mean PAR')
set(gca,'FontSize',24)

h.axPerformanceIndex = subplot(3,1,3);
plot(iter.performanceIndex);
grid on
xlabel('Iteration Number')
ylabel({'Performance','Index'})
set(gca,'FontSize',24)


linkaxes([h.axSpatialError h.axMeanPAR h.axPerformanceIndex],'x')

end