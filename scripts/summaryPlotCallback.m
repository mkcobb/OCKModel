close all
figure
plotHemisphere
hold on
plotTrajectory
plotBFC
plotPolarUnitVecs
[h.points,h.waypointBounds] = plotWaypoints(p,gca);
xlim([0 2*r])
ylim([-r r])
zlim([0 r])
axis square
axis fill
view([75 30])
xlabel('x, [m]')
ylabel('y, [m]')
zlabel('z, [m]')
h.legend = legend([h.trajectory h.BFCXInit h.BFCXFinal h.rUnitVecInit h.rUnitVecFinal h.points h.waypointBounds(1)],...
    {'Path','BFC Init','BFC Final','Unit Vecs Init','Unit Vecs Final','Waypoint','Waypoint Bounds'});

figure
h.headingSummaryPlot = subplot(2,1,1);
h.headingSetpointRad = plot(tsc.headingSetpointRad);
hold on
h.headingSPRefModel  = plot(tsc.psiSP);
h.heading            = plot(tsc.psi);
xlabel('time, t [s]')
legend([h.headingSetpointRad h.headingSPRefModel h.heading],{'Heading SP: Raw','Heading SP: Ref. Mod.','Heading'})
title('Heading Summary')

h.waypointErrorSummaryPlot = subplot(2,1,2);
h.thetaError = plot(tsc.thetaErrorDeg);
hold on
h.psiError   = plot(tsc.psiErrorDeg);
h.upperLim = line(get(gca,'XLim'),p.waypointThetaTol*[1 1]*(180/pi),'Color','g');
h.lowerLim = line(get(gca,'XLim'),-p.waypointThetaTol*[1 1]*(180/pi),'Color','g');
xlabel('time, t [s]')
legend([h.thetaError h.psiError h.upperLim h.lowerLim],{'Theta Error','Psi Error','Lower Lim','Upper Lim'})
linkaxes([h.headingSummaryPlot h.waypointErrorSummaryPlot],'x');


