function animateSingleLap(lapNumber,p,tsc,filePath)
fileName = sprintf('lap_%s_%s',num2str(lapNumber),datestr(now,'ddmmyyyy_hhMMss'));
animtationFilePath = fullfile(filePath,'animations',[fileName,'.gif']);
videoFilePath = fullfile(filePath,'animations',fileName);
frameRate = 1/0.002;

times = tsc.time(tsc.currentIterationNumber.data == lapNumber);

tsc = getsampleusingtime(tsc,times(1),times(end));

[sphereX,sphereY,sphereZ] = sphere(100);
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;

if size(get(groot,'MonitorPositions'),1)>1
    h.fig = figure('units','normalized','position',[-1 0 1 0.95]);
else
    h.fig = figure('units','normalized','position',[0 0 1 0.95]);
end
% h.ax = h.fig.Children;
% h.ax.Position = [0 0.025 1 0.95];

h.sphere = surf(sphereX,sphereY,sphereZ,...
    'EdgeColor','none','FaceAlpha',0.25);
hold on
set(h.sphere,'FaceColor',[0 0 0])



basisParams = (180/pi)*tsc.basisParams.data(1,:);

[pathAzimuth,~,pathZenith] = generateWaypoints(1000,basisParams(1),basisParams(2),p.elev);
[pathX,pathY,pathZ]=sphere2cart(p.initPositionGFS(1),pathAzimuth,pathZenith);

plot3(pathX,pathY,pathZ)
axis equal
% xlim([0 p.initPositionGFS(1)])
% ylim( p.initPositionGFS(1)*[-1 1])
% zlim([0 p.initPositionGFS(1)])

xlim([min(pathX) max(pathX)])
ylim([min(pathY) max(pathY)])
zlim([min(pathZ) max(pathZ)])
view(60,30)


tsc = resample(tsc,0:1/frameRate:tsc.time(end));
targetWaypoints    = tsc.targetWaypoint.data;
targetWaypointsGFS = [p.initPositionGFS(1)*ones(size(targetWaypoints(:,1))) targetWaypoints];
[targetWaypointsX,targetWaypointsY,targetWaypointsZ] = ...
    sphere2cart(targetWaypointsGFS(:,1),targetWaypointsGFS(:,2),targetWaypointsGFS(:,3));

closestPoints    = tsc.closestPoint.data;
closestPointsGFS = [p.initPositionGFS(1)*ones(size(closestPoints(:,1))) closestPoints];
[closestPointsX,closestPointsY,closestPointsZ] = ...
    sphere2cart(closestPointsGFS(:,1),closestPointsGFS(:,2),closestPointsGFS(:,3));
closestPoints = [closestPointsX,closestPointsY,closestPointsZ]; 


positionsGFC = tsc.positionGFC.data;
positionsGFS = tsc.positionGFS.data;

cartesianDistance = sqrt(sum(closestPoints-positionsGFC,2).^2);


phi1 = pi/2-positionsGFS(:,3);
phi2 = pi/2-closestPointsGFS(:,3);
lambda1 = positionsGFS(:,2);
lambda2 = closestPointsGFS(:,2);

sphericalDistance = 2*p.initPositionGFS(1)*asin(sqrt(sin((abs(phi2-phi1))/2).^2+cos(phi1).*cos(phi2).*sin((abs(lambda2-lambda1))/2).^2));

% figure;
% plot(sphericalDistance)
% hold on
% plot(tsc.minimumDistanceToPath.data)
% plot(cartesianDistance);


set(gca,'FontSize',24)
frame = struct('cdata', cell(1,length(tsc.time)), 'colormap', cell(1,length(tsc.time)));
for ii = 1:length(tsc.time)
    
    if ii == 1
        h.position = animatedline(positionsGFC(1,1),positionsGFC(1,2),positionsGFC(1,3));
        h.targetWaypoint = scatter3(targetWaypointsX(1),targetWaypointsY(2),targetWaypointsZ(3));
        h.closestPoint = scatter3(closestPointsX(1),closestPointsY(1),closestPointsZ(1),'CData',[0 1 0]);
        h.text = text(0.5,0.05,{...
            sprintf('Online Min Sperical Distance   = %s',num2str(tsc.minimumDistanceToPath.data(ii))),...
            sprintf('Offline Min Sperical Distance  = %s',num2str(sphericalDistance(ii))),...
            sprintf('Offline Min Cartesian Distance = %s',num2str(cartesianDistance(ii)))},...
            'Units','normalized','FontSize',24);
    else
        addpoints(h.position,positionsGFC(ii,1),positionsGFC(ii,2),positionsGFC(ii,3))
        h.targetWaypoint.XData = targetWaypointsX(ii);
        h.targetWaypoint.YData = targetWaypointsY(ii);
        h.targetWaypoint.ZData = targetWaypointsZ(ii);
        h.closestPoint.XData = closestPointsX(ii);
        h.closestPoint.YData = closestPointsY(ii);
        h.closestPoint.ZData = closestPointsZ(ii);
        h.text.String = {...
            sprintf('Online Min Sperical Distance   = %s',num2str(tsc.minimumDistanceToPath.data(ii))),...
            sprintf('Offline Min Sperical Distance  = %s',num2str(sphericalDistance(ii))),...
            sprintf('Offline Min Cartesian Distance = %s',num2str(cartesianDistance(ii)))};
        drawnow
    end
    
%     title(sprintf('Online Min Distance = %s',num2str(tsc.minimumDistanceToPath.data(ii))))
    frame(ii) = getframe(h.fig);
    im = frame2im(frame(ii));
    [imind,cm] = rgb2ind(im,256);
    % On the first loop, create the file. In subsequent loops, append.
    if ii == 1
        imwrite(imind,cm,animtationFilePath,'gif','DelayTime',0,'loopcount',1);
    else
        imwrite(imind,cm,animtationFilePath,'gif','DelayTime',1/frameRate,'writemode','append');
    end
    
end
v = VideoWriter(videoFilePath,'Uncompressed AVI');
open(v);
writeVideo(v,frame)
close(v)
end