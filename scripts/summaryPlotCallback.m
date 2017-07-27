close all
r = p.initPosition(1);
subplot(3,2,[1 3 5])
plotHemisphere
hold on
plotTrajectory
plotBFC
plotPolarUnitVecs
% plotAxes
xlim([0 2*r])
ylim([-r r])
zlim([0 2*r])
axis square
view([75 30])
xlabel('x, [m]')
ylabel('y, [m]')
zlabel('z, [m]')

subplot(3,2,2)
plot(tsc.alpha)

subplot(3,2,4)
plot(tsc.beta)

subplot(3,2,6)
plot(tsc.omega)

figure
subplot(3,2,1)
plot(tsc.velocityGFC.time,sqrt(sum(tsc.velocityGFC.data.^2,2)))
title('Velocity')

subplot(3,2,3)
plot(tsc.MxBFC)

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