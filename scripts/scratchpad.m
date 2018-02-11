% close all;
% figure
% idx = tsc.currentIterationNumber.data<3;
% p=simulationParametersClass;
% p.width = 110;p.height=20;
%
% % Plot waypoints
% hWaypoints = scatter((180/pi)*([p.initialWaypointAzimuths(1) p.initialWaypointAzimuths]),...
%     (180/pi)*(pi/2-[p.initialWaypointZeniths(1) p.initialWaypointZeniths]),...
%     'Marker','x','SizeData',300,'LineWidth',3,'CData',[1 0 0],'MarkerFaceColor','r');
% hold on
% % Plot Path
% hPath = plot((180/pi)*(tsc.positionGFS.data(idx,2)),...
%     (180/pi)*(pi/2-tsc.positionGFS.data(idx,3)),'Color','b');
% % Plot Waypoint Boundaries
% for ii = 1:length(p.initialWaypointAzimuths)
%    plot((180/pi)*(p.initialWaypointAzimuths(ii)+p.waypointAzimuthTol*[1 -1 -1 1 1]),...
%        (180/pi)*((pi/2-(p.initialWaypointZeniths(ii)+ p.waypointZenithTol*[1 1 -1 -1 1]))),...
%        'Color','k','LineStyle',':')
% end
% grid on
% xlabel('Azimuth Waypoing Position, [deg]')
% ylabel('Elevation Waypoint Position, [deg]')
% title('Waypoint Position - Spherical Coordinates')
% set(gca,'FontSize',30)
% uistack(hWaypoints,'top')
%
% figure
% ax1=subplot(2,1,1);
% plot(tsc.time(idx),tsc.headingSetpointRad.data(idx))
% hold on
% plot(tsc.time(idx),tsc.headingDes.data(idx))
% plot(tsc.time(idx),tsc.heading.data(idx))
% grid on
% legend('Setpoint','Desired','Actual')
% ax2=subplot(2,1,2);
% plot(tsc.time(idx),tsc.alphaRudderEffective.data(idx))
% grid on
% linkaxes([ax1 ax2],'x')
%
% figure
% tsc.BFXDot.plot
waypointUpdateTrigger = getElement(logsout,'waypointUpdateTrigger');
waypointUpdateTrigger = waypointUpdateTrigger.Values;

performanceIndex = getElement(logsout,'performanceIndex');
performanceIndex = performanceIndex.Values;

performanceIndex = getElement(logsout,'performanceIndex');
performanceIndex = performanceIndex.Values;

meanPAR = getElement(logsout,'meanPAR');
meanPAR = meanPAR.Values;

normalizedSpatialError = getElement(logsout,'normalizedSpatialError');
normalizedSpatialError = normalizedSpatialError.Values;

close all

figure
ax1 = subplot(5,1,1);
plot(waypointUpdateTrigger.data)
ylabel('Waypoint Updt. Trigger')

ax2 = subplot(5,1,2);
plot(performanceIndex.data)
ylabel('Online J')

ax3 = subplot(5,1,3);
plot(meanPAR.data)
ylabel('Mean PAR')

ax4 = subplot(5,1,4);
plot(normalizedSpatialError.data)
ylabel('NSE')

ax5 = subplot(5,1,5);
plot(meanPAR.data-p.weightNSE*normalizedSpatialError.data)
ylabel('Offline J')

linkaxes([ax1 ax2 ax3 ax4 ax5],'x')