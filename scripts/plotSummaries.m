close all



%% Path Summary
figure
plotHemisphere
hold on
plotTrajectory
plotBFC
plotPolarUnitVecs
[h.points,h.waypointBounds] = plotWaypoints(p,gca);
if abs(p.width)>90
    xlim(p.initPositionGFS(1)*[-1 1])
else
    xlim([0 2*p.initPositionGFS(1)])
end
ylim(p.initPositionGFS(1)*[-1 1])
zlim([0 p.initPositionGFS(1)])
axis square
axis fill
view([75 30])
xlabel('x, [m]')
ylabel('y, [m]')
zlabel('z, [m]')
h.legend = legend([h.trajectory h.BFCXInit h.BFCXFinal h.rUnitVecInit h.rUnitVecFinal h.points h.waypointBounds(1)],...
    {'Path','BFC Init','BFC Final','Unit Vecs Init','Unit Vecs Final','Waypoint','Waypoint Bounds'});

%% Heading Summary
figure
h.headingSummaryPlot = subplot(2,1,1);
h.headingSetpointRad = plot(tsc.headingSetpointRad);
hold on
h.headingSPRefModel  = plot(tsc.psiSP);
h.heading            = plot(tsc.psi);
markWaypoints
xlabel('time, t [s]')
legend([h.headingSetpointRad h.headingSPRefModel h.heading],{'Heading SP: Raw','Heading SP: Ref. Mod.','Heading'})
title('Heading Summary')

h.waypointErrorSummaryPlot = subplot(2,1,2);
h.thetaError = plot(tsc.thetaErrorDeg);
hold on
h.psiError   = plot(tsc.psiErrorDeg);
h.upperLim = line(get(gca,'XLim'),p.waypointThetaTol*[1 1]*(180/pi),'Color','g');
h.lowerLim = line(get(gca,'XLim'),-p.waypointThetaTol*[1 1]*(180/pi),'Color','g');
markWaypoints
xlabel('time, t [s]')
legend([h.thetaError h.psiError h.upperLim h.lowerLim],{'Theta Error','Psi Error','Lower Lim','Upper Lim'})
linkaxes([h.headingSummaryPlot h.waypointErrorSummaryPlot],'x');


%% Rudder Aerodynamics Summary
figure
h.rudderAngle = subplot(2,1,1);
h.rudderAnglePlot = plot(tsc.rudderAngle);
h.limUp1 = line(get(gca,'XLim'),pi*[1 1],'Color','g');
h.limDn1 = line(get(gca,'XLim'),-pi*[1 1],'Color','g');
h.limUp2 = line(get(gca,'XLim'),pi/2*[1 1],'Color','r');
h.limDn2 = line(get(gca,'XLim'),-pi/2*[1 1],'Color','r');
markWaypoints
xlabel('time, t [s]')
title('Rudder Angle')
legend([h.rudderAnglePlot h.limUp1 h.limUp2],{'Rudder Angle','+/- Pi','+/- Pi/2'})

h.rudderCl = subplot(2,1,2);
h.rudderCLPlot = plot(tsc.ClRudder);
h.rudderCLMax = line(get(gca,'XLim'),max(rudderTable.cl)*[1 1],'Color','r');
h.rudderCLMin = line(get(gca,'XLim'),min(rudderTable.cl)*[1 1],'Color','r');
markWaypoints
xlabel('time, t [s]')
title('Rudder C_L')
legend([h.rudderCLPlot h.rudderCLMax],{'Rudder C_L','Min/Max C_L from Table'})

linkaxes([h.rudderAngle h.rudderCl],'x')

%% Power Energy Generation Summary
figure
h.BFCXSpeed = subplot(3,1,1);
plot(tsc.BFXDot)
markWaypoints

h.powerFactor = subplot(3,1,2);
plot(tsc.powerFactor)
markWaypoints

h.meanEnergy = subplot(3,1,3);
plot(tsc.meanEnergy)
markWaypoints

linkaxes([h.BFCXSpeed h.powerFactor h.meanEnergy],'x')

