function h = plotSingleLap(lapNumber)
% Extract the apropriate data
tsc = evalin('base','tsc');
p = evalin('base','p');
times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
tsc = getsampleusingtime(tsc,times(1),times(end));

[sphereX,sphereY,sphereZ] = sphere(100);
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;

h.fig = createFigure();

h.sphere = surf(sphereX,sphereY,sphereZ,...
    'EdgeColor','none','FaceAlpha',0.25);
hold on
set(h.sphere,'FaceColor',[0 0 0])

basisParams = (180/pi)*tsc.basisParams.data(1,:);

[pathAzimuth,~,pathZenith] = generateWaypoints(1000,basisParams(1),basisParams(2),p.elev);
[pathX,pathY,pathZ]=sphere2cart(p.initPositionGFS(1),pathAzimuth,pathZenith);
positionsGFC = tsc.positionGFC.data;
plot3(pathX,pathY,pathZ)
plot3(positionsGFC(:,1),positionsGFC(:,2),positionsGFC(:,3));
axis equal
xlim([min(pathX) max(pathX)])
ylim([min(pathY) max(pathY)])
zlim([min(pathZ) max(pathZ)])
view(60,30)
end