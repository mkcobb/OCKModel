function h = comparePerformanceIndices(initialCondition)
initialCondition = lower(initialCondition);
load(fullfile(pwd,'paperData',sprintf('%s_baseline.mat',initialCondition)),'iter');

h.figure = createFigure();

h.axSpatialError = subplot(3,1,1);
plot(iter.startTimes/60,iter.spatialError,'DisplayName','Baseline');
grid on
hold on
legend
xlabel('Time, t [min]')
ylabel('Spatial Error')
title(['Initial Condition: ' upper(initialCondition(1)) initialCondition(2:end)])
set(gca,'FontSize',24)

h.axMeanPAR = subplot(3,1,2);
plot(iter.startTimes/60,iter.meanPAR,'DisplayName','Baseline');
grid on
hold on
legend
xlabel('Time, t [min]')
ylabel('Mean PAR')
set(gca,'FontSize',24)

h.axPerformanceIndex = subplot(3,1,3);
plot(iter.startTimes/60,iter.performanceIndex,'DisplayName','Baseline');
grid on
hold on
legend
xlabel('Time, t [min]')
ylabel({'Performance','Index'})
set(gca,'FontSize',24)

linkaxes([h.axSpatialError h.axMeanPAR h.axPerformanceIndex],'x')

load(fullfile(pwd,'paperData',sprintf('%s_optimization.mat',initialCondition)),'iter');
plot(iter.startTimes/60,iter.spatialError,'DisplayName','Optimization','Parent',h.axSpatialError);
plot(iter.startTimes/60,iter.meanPAR,'DisplayName','Optimization','Parent',h.axMeanPAR);
plot(iter.startTimes/60,iter.performanceIndex,'DisplayName','Optimization','Parent',h.axPerformanceIndex);

savePlot(h.figure,sprintf('%s_performanceIndexComparison',initialCondition))
end