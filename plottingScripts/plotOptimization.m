close all
%% Plot response surface + design space
azimuth = linspace(min(iter.basisParams(:,1)),max(iter.basisParams(:,1)));
zenith  = linspace(min(iter.basisParams(:,2)),max(iter.basisParams(:,2)));
[azimuth,zenith] = meshgrid(azimuth,zenith);
beta = tsc.beta.data(:,:,end);

approxSurf = beta(1) + beta(2)*azimuth + beta(3)*azimuth.^2 + ...
    beta(4)*zenith + beta(5)*zenith.^2;


surf((180/pi)*azimuth,(180/pi)*zenith,approxSurf,'EdgeColor','none')
hold on
scatter3((180/pi)*iter.basisParams(p.numSettlingLaps:end-1,1),...
    (180/pi)*iter.basisParams(p.numSettlingLaps:end-1,2),...
    iter.performanceIndex(p.numSettlingLaps:end-1),...
    'MarkerFaceColor','flat','CData',[0 0 0])
plot3((180/pi)*iter.basisParams(p.numSettlingLaps:end-1,1),...
    (180/pi)*iter.basisParams(p.numSettlingLaps:end-1,2),...
    iter.performanceIndex(p.numSettlingLaps:end-1))
scatter3((180/pi)*iter.basisParams(end,1),...
    (180/pi)*iter.basisParams(end,2),...
    iter.performanceIndex(end),...
    'MarkerFaceColor','flat','CData',[1 0 0],'SizeData',72)

xlabel('Width, Azimuth Sweep, [deg]')
ylabel('Height, Zenith Sweep, [deg]')
zlabel('Performance Index')
zlim([min(min(iter.performanceIndex(p.numSettlingLaps:end-1))) max(max(iter.performanceIndex(p.numSettlingLaps:end-1)))])
% ylim([min(min(approxSurf)) max(max(approxSurf))])


%% Plot cost function
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
plot(iter.performanceIndexTrackingTerm(p.numSettlingLaps:end-1),...
    'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
addPhaseMarkers
grid on
xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
ylim(yLimits)
xlabel('Iteration Number')
ylabel({'Spatial Error','Term'})
set(gca,'FontSize',20)




