close all;bdclose all;clear;clc;

p = simulationParametersClass;

hFig = figure;
[sphereX,sphereY,sphereZ] = sphere(100);
hSphere = surf(sphereX,sphereY,sphereZ)
hold on
hSphere.EdgeColor = 'none'
colormap(gca, gray(256))
hSphere.CData = 0.01*ones(size(hSphere.CData));
hSphere.FaceAlpha = 0.5;
axis equal

xlim([0 1])
ylim([-1 1])
zlim([0 1])
axis off
% set(gca,'LooseInset',get(gca,'TightInset'))
set(gca,'Units','Normalized','Position',[0 0 1 1])
view([60 20])


hXAxisExtension = plot3([0 1],[0 0],[0 0],'Color',0.7*[1 1 1],'LineStyle','--');
hYAxisExtension = plot3([0 0],[0 1],[0 0],'Color',0.7*[1 1 1],'LineStyle','--');
hZAxisExtension = plot3([0 0],[0 0],[0 1],'Color',0.7*[1 1 1],'LineStyle','--');

unitAxisLength = 0.25;
hXAxis = plot3(unitAxisLength*[0 1],[0 0],[0 0],'Color','k');
hYAxis = plot3([0 0],unitAxisLength*[0 1],[0 0],'Color','k');
hZAxis = plot3([0 0],[0 0],unitAxisLength*[0 1],'Color','k');


waypointAngles = linspace((3/2)*pi,(7/2)*pi)';
radius = ones(size(waypointAngles));
azimuth = 45*(pi/180)*cos(waypointAngles);
elevation = (45 - 15*cos(waypointAngles).*sin(waypointAngles))*(pi/180);

[x,y,z]=sph2cart(azimuth,elevation,radius);
hPath = plot3(x,y,z,'Color',0.9*[1 1 1])
currentWaypoint = 47;
position = [x(currentWaypoint) y(currentWaypoint) z(currentWaypoint)];
velocity = [x(currentWaypoint-1) y(currentWaypoint-1) z(currentWaypoint-1)]-position;
BFAxisSize = 0.25;
velocity = BFAxisSize*velocity./norm(velocity);

hPosition = plot3([0 x(currentWaypoint)],[0 y(currentWaypoint)],[0 z(currentWaypoint)],'Color',[0 0 0])
hProjection1 = plot3(x(currentWaypoint)*[1 1],y(currentWaypoint)*[1 1],[0 z(currentWaypoint)],'Color',0.2*[1 1 1],'LineStyle','--')
hProjection1 = plot3(x(currentWaypoint)*[0 1],y(currentWaypoint)*[0 1],[0 0],'Color',0.2*[1 1 1],'LineStyle','--')
hVelocity = quiver3(position(1),position(2),position(3),velocity(1),velocity(2),velocity(3),'Color','k','LineWidth',2,'ShowArrowHead','off')
BFYAxis = cross(velocity,position);
BFYAxis = -BFAxisSize*(BFYAxis./norm(BFYAxis));
hBFYaxis = quiver3(position(1),position(2),position(3),BFYAxis(1),BFYAxis(2),BFYAxis(3),'Color','k','LineWidth',2,'ShowArrowHead','off')

BFZAxis = position;
BFZAxis = BFAxisSize*(BFZAxis./norm(BFZAxis));
hBFZaxis = quiver3(position(1),position(2),position(3),BFZAxis(1),BFZAxis(2),BFZAxis(3),'Color','k','LineWidth',2,'ShowArrowHead','off')

CEAzimuths   = linspace(-pi/2,pi/2);
CERadii      = ones(size(CEAzimuths));
CEElevations = elevation(currentWaypoint)*ones(size(CEAzimuths));
[xCE,yCE,zCE] = sph2cart(CEAzimuths,CEElevations,CERadii);

hCELine = plot3(xCE,yCE,zCE,'Color','k','LineStyle',':')

hFig.PaperOrientation = 'landscape';
saveas(hFig,fullfile(pwd,'figures','png','Schematic_a.png'));
saveas(hFig,fullfile(pwd,'figures','eps','Schematic_a.eps'),'epsc')
saveas(hFig,fullfile(pwd,'figures','fig','Schematic_a.fig'));

