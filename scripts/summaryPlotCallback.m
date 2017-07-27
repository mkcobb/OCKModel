close all
r = p.initPosition(1);
plotHemisphere
hold on
plotTrajectory
plotAxes
xlim([0 2*r])
ylim([-r r])
zlim([0 2*r])
axis square
view([75 30])