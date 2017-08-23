close all
r = p.initPositionGFS(1);
figure
plotHemisphere
hold on
plotTrajectory
plotBFC
plotPolarUnitVecs
plotWaypoints(p.waypoints,p.initPositionGFS(1),gca);
% plotAxes
xlim([0 2*r])
ylim([-r r])
zlim([0 r])
axis square
axis fill
view([75 30])
xlabel('x, [m]')
ylabel('y, [m]')
zlabel('z, [m]')
legend([h.trajectory h.BFCinit h.BFCFinal h.unitVecsInit h.unitVecsFinal],{'Path','BFC Init','BFC Final','Unit Vecs Init','Unit Vecs Final'})
% 
% figure
% subplot(3,2,1)
% plot(tsc.velocityGFC.time,sqrt(sum(tsc.velocityGFC.data.^2,2)))
% title('Velocity')
% 
% subplot(3,2,3)
% plot(tsc.MzBFC)
% 
% subplot(3,2,5)
% plot(tsc.psi)
% 
% subplot(3,2,2)
% plot(tsc.rollDeg)
% 
% subplot(3,2,4)
% plot(tsc.pitchDeg)
% 
% subplot(3,2,6)
% plot(tsc.yawDeg)
% 
% figure
% subplot(3,1,1)
% plot(tsc.FWingBFC)
% 
% subplot(3,1,2)
% plot(tsc.FRudderBFC)
% 
% subplot(3,1,3)
% plot(tsc.FGravityBFC)
% 
% figure
% h.wingAnglePreSat = plot(tsc.wingAngleCmdPreSat);
% hold on
% h.wingAngleCmd = plot(tsc.wingAngleCmd);
% h.wingAngleUpperSat = plot(tsc.wingAngleUpperSat);
% h.wingAngleLowerSat = plot(tsc.wingAngleLowerSat);
% h.wingAngleTableMax = line(get(gca,'XLim'),max(wingTable.alpha)*[1 1],'Color','r','LineStyle','--');
% h.wingAngleTableMin = line(get(gca,'XLim'),min(wingTable.alpha)*[1 1],'Color','r','LineStyle','--');
% h.alphaWing = plot(tsc.alphaWing);
% h.alphaWingEffective = plot(tsc.alphaWingEffective);
% legend([h.wingAnglePreSat h.wingAngleCmd h.wingAngleUpperSat h.wingAngleLowerSat h.wingAngleTableMax h.wingAngleTableMin h.alphaWing h.alphaWingEffective],...
%     {'wing angle pre sat','wing angle cmd','upper sat','lower sat','table max','table min','alpha wing','alpha wing effective'})
% 
% 
figure
subplot(2,1,1)
plot(tsc.headingSetpointRad)
hold on
plot(tsc.psiSP)
plot(tsc.psi)
line(get(gca,'XLim'),pi*[1 1])
line(get(gca,'XLim'),-pi*[1 1])


subplot(2,1,2)
plot(tsc.thetaErrorDeg)
hold on
plot(tsc.psiErrorDeg)
line(get(gca,'XLim'),p.waypointThetaTol*[1 1]*(180/pi))
line(get(gca,'XLim'),-p.waypointThetaTol*[1 1]*(180/pi))



