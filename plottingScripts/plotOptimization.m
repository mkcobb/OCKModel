close all
%% Plot performance index
figure
subplot(2,2,1)
plot(iter.performanceIndex(p.numSettlingLaps:end-1),...
    'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
addPhaseMarkers
grid on
xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
ylim(yLimits)
xlabel('Iteration Number')
ylabel('Performance Index')
set(gca,'FontSize',20)

subplot(2,2,2)
plot(iter.meanEnergy(p.numSettlingLaps:end-1),...
    'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
addPhaseMarkers
grid on
xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
ylim(yLimits)
xlabel('Iteration Number')
ylabel({'Mean Energy','Term'})
set(gca,'FontSize',20)

subplot(2,2,3)
plot(iter.meanPAR(p.numSettlingLaps:end-1),...
    'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
addPhaseMarkers
grid on
xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
ylim(yLimits)
xlabel('Iteration Number')
ylabel({'Mean PAR','Term'})
set(gca,'FontSize',20)

subplot(2,2,4)
plot(iter.normalizedSpatialError(p.numSettlingLaps:end-1),...
    'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
addPhaseMarkers
grid on
xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
ylim(yLimits)
xlabel('Iteration Number')
ylabel({'Spatial Error','Term'})
set(gca,'FontSize',20)




