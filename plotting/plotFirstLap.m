close all;
clc;
% startTime = tsc.time(1);
% endTime = tsc.time(diff(tsc.indexOfClosestPoint.data(:))<0);
% endTime = endTime(1) +2*p.Ts;


% tsc = getsampleusingtime(tsc,startTime,endTime);

figure;

plot(tsc.positionGFS.data(:,2),tsc.positionGFS.data(:,3))
hold on
scatter(tsc.targetWaypoint.data(:,1),tsc.targetWaypoint.data(:,2),'x')

figure
tsc.headingSetpoint.plot
hold on
tsc.headingDes.plot
tsc.heading.plot


figure
tsc.targetedWaypointIndex.plot