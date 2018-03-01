function animateSingleLap(lapNumber,frameRate)
p = evalin('base','p');
tsc = evalin('base','tsc');

% Clean up lap number to be sure that it fits the necessary structure
lapNumber = round(sort(lapNumber));
lapNumber = lapNumber(1):min([tsc.currentIterationNumber.data(end) lapNumber(2)]);


filePath = fileparts(fileparts(which(mfilename)));
fileName = sprintf('lap_%s_to_%s_%s',num2str(lapNumber(1)),num2str(lapNumber(end)),datestr(now,'ddmmyyyy_hhMMss'));
animtationFilePath = fullfile(filePath,'animations',[fileName,'.gif']);
videoFilePath = fullfile(filePath,'animations',fileName);

times = tsc.time(tsc.currentIterationNumber.data == lapNumber(1));
for ii = 2:length(lapNumber)
    times = [times;tsc.time(tsc.currentIterationNumber.data == lapNumber(ii))];
end

tsc = getsampleusingtime(tsc,times(1),times(end));

[sphereX,sphereY,sphereZ] = sphere(100);
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;

if size(get(groot,'MonitorPositions'),1)>1
    h.fig = figure('units','normalized','position',[-1 0 1 0.9]);
else
    h.fig = figure('units','normalized','position',[0 0 1 0.9]);
end
h.sphere = surf(sphereX,sphereY,sphereZ,...
    'EdgeColor','none','FaceAlpha',0.25);
hold on
set(h.sphere,'FaceColor',[0 0 0])

basisParams = (180/pi)*tsc.basisParams.data(1,:);

[pathAzimuth,~,pathZenith] = generateWaypoints(1000,basisParams(1),basisParams(2),p.elev);
[pathX,pathY,pathZ] = sphere2cart(p.initPositionGFS(1),pathAzimuth,pathZenith);

h.path = plot3(pathX,pathY,pathZ);
axis equal
% Set the limits to give "global" view
% xlim([0 p.initPositionGFS(1)])
% ylim( p.initPositionGFS(1)*[-1 1])
% zlim([0 p.initPositionGFS(1)])

% Set the limits to give a "zoomed in" view
xlim([min(pathX) max(pathX)])
ylim([min(pathY) max(pathY)])
zlim([min(pathZ) max(pathZ)])
view(90,30)


tsc = resample(tsc,tsc.time(1):1/frameRate:tsc.time(end));
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

h.ax = gca;
h.ax.Units = 'Normalized';
h.ax.Position = h.ax.Position + [0.125 0 -0.05 0];
h.ax.FontSize = 24;
frame = struct('cdata', cell(1,length(tsc.time)), 'colormap', cell(1,length(tsc.time)));
for ii = 1:length(tsc.time)
    
    if ii == 1
        h.position = animatedline(positionsGFC(1,1),positionsGFC(1,2),positionsGFC(1,3));
        h.targetWaypoint = scatter3(targetWaypointsX(1),targetWaypointsY(2),targetWaypointsZ(3));
        h.closestPoint = scatter3(closestPointsX(1),closestPointsY(1),closestPointsZ(1),'CData',[0 1 0]);
        
        
        colNames = {...
            '<html><font face = "verdana" size = 5>Description</font></html>',...
            '<html><font face = "verdana" size = 5>Value</font></html>',...
            '<html><font face = "verdana" size = 5>Units</font></html>'};
       
        data = {...
            'Time',                     sprintf('%.3f',tsc.time(ii)),                       's';...
            'Video Frame',              num2str(ii),                                        '-';...
            'Iteration Number',         num2str(tsc.currentIterationNumber.data(ii)),       '-';...
            'Online Min Sphere Dist',   sprintf('%.4f',tsc.minimumDistanceToPath.data(ii)), 'm';...
            'Offline Min Sphere Dist',  sprintf('%.4f',sphericalDistance(ii)),              'm';...
            'Offline Min Cart Dist',    sprintf('%.4f',cartesianDistance(ii)),              'm';...
            'Closest Index',            num2str(tsc.indexOfClosestPoint.data(ii)),          '-';...
            'Offset From Closest Index',num2str(tsc.offsetFromStart.data(ii)),              '-';...
            'Speed',                    num2str(tsc.BFXDot.data(ii)),                       'm/s';...
            'Heading Setpoint',         sprintf('%.4f',tsc.headingSetpoint.data(ii)*(180/pi)),'deg';...
            'Heading Desired',          sprintf('%.4f',tsc.headingDes.data(ii)*(180/pi)),            'deg';...
            'Heading',                  sprintf('%.4f',tsc.heading.data(ii)*(180/pi)),               'deg'};
        
        h.table = uitable('Data',data,'ColumnName',colNames,...
            'Units', 'Normalized');
        h.table.Position = [0, 0, 0.25, 1];
        h.table.FontSize = 16;
        h.table.ColumnWidth = {240,120,'auto'};
         
    else
        addpoints(h.position,positionsGFC(ii,1),positionsGFC(ii,2),positionsGFC(ii,3))
        h.targetWaypoint.XData = targetWaypointsX(ii);
        h.targetWaypoint.YData = targetWaypointsY(ii);
        h.targetWaypoint.ZData = targetWaypointsZ(ii);
        h.closestPoint.XData = closestPointsX(ii);
        h.closestPoint.YData = closestPointsY(ii);
        h.closestPoint.ZData = closestPointsZ(ii);

        h.table.Data(:,2)={...
            sprintf('%.3f',tsc.time(ii)),;...
            num2str(ii);...
            num2str(tsc.currentIterationNumber.data(ii));...
            sprintf('%.4f',tsc.minimumDistanceToPath.data(ii));...
            sprintf('%.4f',sphericalDistance(ii));...
            sprintf('%.4f',cartesianDistance(ii));...
            num2str(tsc.indexOfClosestPoint.data(ii));...
            num2str(tsc.offsetFromStart.data(ii));...
            num2str(tsc.BFXDot.data(ii));...
            sprintf('%.4f',tsc.headingSetpoint.data(ii)*(180/pi));...
            sprintf('%.4f',tsc.headingDes.data(ii)*(180/pi));...
            sprintf('%.4f',tsc.heading.data(ii)*(180/pi))};
        drawnow
    end
    
    %    
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