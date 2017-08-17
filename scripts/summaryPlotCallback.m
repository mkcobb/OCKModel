close all
r = p.initPositionGFS(1);

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

figure
subplot(3,2,1)
plot(tsc.velocityGFC.time,sqrt(sum(tsc.velocityGFC.data.^2,2)))
title('Velocity')

subplot(3,2,3)
plot(tsc.MzBFC)

subplot(3,2,5)
plot(tsc.twist)

subplot(3,2,2)
plot(tsc.roll)

subplot(3,2,4)
plot(tsc.pitch)

subplot(3,2,6)
plot(tsc.yaw)

figure
subplot(3,1,1)
plot(tsc.FWingBFC)

subplot(3,1,2)
plot(tsc.FRudderBFC)

subplot(3,1,3)
plot(tsc.FGravityBFC)