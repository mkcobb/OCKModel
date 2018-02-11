function  plotTrajectory(tscc,idx)
tsc=tscc{idx};
[x,y,z]=sphere;
x=tsc.positionGFS.data(1,1)*x;
y=tsc.positionGFS.data(1,1)*y;
z=tsc.positionGFS.data(1,1)*z;
plot3(tsc.positionGFC.data(:,1),...
    tsc.positionGFC.data(:,2),...
    tsc.positionGFC.data(:,3));
hold on
surf(x,y,z,'EdgeColor','none','FaceAlpha',0.5);
grid on

axis equal
view([60 30])
xlim([0 tsc.positionGFS.data(1,1)])
ylim(tsc.positionGFS.data(1,1)*[-1 1])
zlim([0 tsc.positionGFS.data(1,1)])
xlabel('x position, [m]')
ylabel('y position, [m]')
zlabel('z position, [m]')
end