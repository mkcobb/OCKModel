function animateSingleLap(lapNumber,frameRate)

p = evalin('base','p');

% Set the scale factor for the body fixed axes
axesScaleFactor = 3;

% Set up the save directories/paths
filePath = fileparts(fileparts(which(mfilename)));
fileName = sprintf('lap_%s_to_%s_%s',num2str(lapNumber(1)),num2str(lapNumber(end)),datestr(now,'ddmmyyyy_hhMMss'));
animtationFilePath = fullfile(filePath,'animations',[fileName,'.gif']);
videoFilePath = fullfile(filePath,'animations',fileName);

% get some stuff from the base workspace
p = evalin('base','p');
tsc = evalin('base','tsc');

% Clean up lap number to be sure that it fits the necessary structure
lapNumber = round(sort(lapNumber));
if length(lapNumber)==1
    lapNumber(2) = lapNumber;
end
lapNumber = lapNumber(1):min([tsc.currentIterationNumber.data(end) lapNumber(2)]);

% Get the iteration start and end times
times = tsc.time(tsc.currentIterationNumber.data == lapNumber(1));
for ii = 2:length(lapNumber)
    times = [times;tsc.time(tsc.currentIterationNumber.data == lapNumber(ii))];
end

% Crop the timeseries
tsc = getsampleusingtime(tsc,times(1),times(end));

% Resample the dataset
tsc = resample(tsc,tsc.time(1):1/frameRate:tsc.time(end));

% Get the basis parameters for the current iteration
% Take the second element since the signal is logged after a delay
basisParams = (180/pi)*tsc.basisParams.data(2,:);

% Calculate the shape of the path in GFC
[pathAzimuth,~,pathZenith] = generateWaypoints(1000,basisParams(1),basisParams(2),p.elev);
[pathX,pathY,pathZ] = sphere2cart(p.initPositionGFS(1),pathAzimuth,pathZenith);

% Get the surface of the sphere & scale it properly
[sphereX,sphereY,sphereZ] = sphere(100);
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;

% Create a figure
h.fig = createFigure();

% Plot and format the sphere
h.sphere = surf(sphereX,sphereY,sphereZ,...
    'EdgeColor','none','FaceAlpha',0.25);
hold on
set(h.sphere,'FaceColor',[0 0 0])

% Plot and format the path
h.path = plot3(pathX,pathY,pathZ,'LineWidth',2,'DisplayName','Path');
axis equal

h.ax = gca;
h.ax.Units = 'Normalized';
h.ax.Position = h.ax.Position + [0.125 0 -0.05 0];
h.ax.FontSize = 24;

% Highlight the waypoints
h.waypoints = scatter3(pathX(round(p.waypointPathIndices*p.num)),...
    pathY(round(p.waypointPathIndices*p.num)),...
    pathZ(round(p.waypointPathIndices*p.num)),...
    'Marker','x','SizeData',72,'LineWidth',2);

% Set the limits to give "global" view
% xlim([0 p.initPositionGFS(1)])
% ylim( p.initPositionGFS(1)*[-1 1])
% zlim([0 p.initPositionGFS(1)])

% Set the limits to give a "zoomed in" view
xlim([min([pathX tsc.positionGFC.data(:,1)']) max([pathX tsc.positionGFC.data(:,1)'])])
ylim([min([pathY tsc.positionGFC.data(:,2)']) max([pathY tsc.positionGFC.data(:,2)'])])
zlim([min([pathZ tsc.positionGFC.data(:,3)']) max([pathZ tsc.positionGFC.data(:,3)'])])

view(90,30)

pathColors = tsc.vAppWindGFC.data;
pathColors = sum(pathColors.^2,2).^(3/2);
pathColors =(pathColors - min(pathColors))/max(pathColors);
pathColors = [pathColors zeros(size(pathColors)) zeros(size(pathColors))];

frame = struct('cdata', cell(1,length(tsc.time)), 'colormap', cell(1,length(tsc.time)));

h.axRudder = axes(h.fig,'Position',[0.75 0.65 0.3 0.3],'XTickLabel',[],...
    'YTickLabel',[],'XLim',[-1 1],'YLim',[-1 1]);
axis(h.axRudder,'square');
h.axRudder.XAxis.Visible = 'off';
h.axRudder.YAxis.Visible = 'off';
h.circle = viscircles([0 0],1);
h.circle.Children(1).Color = 0.5*[1 1 1];
title('Rudder','FontSize',18)
h.bodyFixedX = line([0 0],[0 1],'Parent',h.axRudder,'Color','k','LineWidth',2);
h.bodyFixedXExtension = line([0 0],[0 -1],'Parent',h.axRudder,'Color',0.5*[1 1 1],'LineWidth',2,'LineStyle','--');

h.axWing = axes(h.fig,'Position',[0.55 0.65 0.3 0.3],'XTickLabel',[],...
    'YTickLabel',[],'XLim',[-1 1],'YLim',[-1 1]);
axis(h.axWing,'square');
h.axWing.XAxis.Visible = 'off';
h.axWing.YAxis.Visible = 'off';
h.circle = viscircles([0 0],1);
h.circle.Children(1).Color = 0.5*[1 1 1];
title('Wing','FontSize',18)
h.bodyFixedXWing = line([-1 0.5],[0 0],'Parent',h.axWing,'Color','k','LineWidth',2);
h.bodyFixedXExtensionWing = line([0.5 1],[0 0],'Parent',h.axWing,'Color',0.5*[1 1 1],'LineWidth',2,'LineStyle','--');


for ii = 1:length(tsc.time)
    
    if ii == 1

        % Plot the current position
        h.position          = scatter3(tsc.positionGFC.data(1,1),...
            tsc.positionGFC.data(1,2),...
            tsc.positionGFC.data(1,3),...
            'Marker','.','LineWidth',1,'DisplayName','Flight Path','CData',pathColors(ii,:),'Parent',h.ax);
        
        % Plot the closest point
        h.closestPoint = scatter3(...
            tsc.closestPointGFC.data(1,1),...
            tsc.closestPointGFC.data(1,2),...
            tsc.closestPointGFC.data(1,3),...
            'Parent',h.ax,'MarkerFaceColor','flat');
        
        
        % Plot the body fixed x axis
        h.BFX = quiver3(tsc.positionGFC.data(1,1),...
            tsc.positionGFC.data(1,2),...
            tsc.positionGFC.data(1,3),...
            axesScaleFactor*tsc.BFX_GFC.data(ii,1),...
            axesScaleFactor*tsc.BFX_GFC.data(ii,2),...
            axesScaleFactor*tsc.BFX_GFC.data(ii,3),...
            'Parent',h.ax,'LineWidth',2,'Color','b');
        
        % Plot the body fixed y axis
        h.BFY = quiver3(tsc.positionGFC.data(1,1),...
            tsc.positionGFC.data(1,2),...
            tsc.positionGFC.data(1,3),...
            axesScaleFactor*tsc.BFY_GFC.data(ii,1),...
            axesScaleFactor*tsc.BFY_GFC.data(ii,2),...
            axesScaleFactor*tsc.BFY_GFC.data(ii,3),...
            'Parent',h.ax,'LineWidth',2,'Color','g');
        
        % Plot line indicating the rudder
        h.rudder = line(sin(tsc.rudderAngle.data(ii))*[1 -1],...
            cos(tsc.rudderAngle.data(ii))*[-1 1],...
            'Parent',h.axRudder,'Color','g','LineWidth',2);
        
        % Plot line indicating the apparent wind relative to the rudder
        h.apparentWindRudder = line([sin(tsc.gammaRudder.data(ii)) 0],...
            [cos(tsc.gammaRudder.data(ii)) 0],...
            'Parent',h.axRudder,'Color','b','LineWidth',2,'LineStyle','--');
        
        % Plot line indicating the wing
         h.wing = line(cos(tsc.wingAngle.data(ii))*[-1 1],...
            sin(tsc.wingAngle.data(ii))*[-1 1],...
            'Parent',h.axWing,'Color','g','LineWidth',2);
        
        % Plot line indicating the apparent wind relative to the wing
        h.apparentWindWing = line(cos(tsc.gammaWing.data(ii))*[1 0],...
            sin(tsc.gammaWing.data(ii))*[-1 0],...
            'Parent',h.axWing,'Color','b','LineWidth',2,'LineStyle','--');
        
        colNames = {...
            '<html><font face = "verdana" size = 5>Description</font></html>',...
            '<html><font face = "verdana" size = 5>Value</font></html>',...
            '<html><font face = "verdana" size = 5>Units</font></html>'};
       
        data = {...
            'Time',                     sprintf('%.3f',tsc.time(ii)),                               's';...
            'Video Frame',              num2str(ii),                                                '-';...
            'Simulation Time Step',     num2str(p.Ts),                                              's';...
            'Animation Time Step',      num2str(1/frameRate),                                       's';...
            'Iteration Number',         num2str(tsc.currentIterationNumber.data(ii)),               '-';...
            'Online Min Sphere Dist',   sprintf('%.4f',tsc.minimumDistanceToPath.data(ii)),         'm';...
            'Closest Index',            num2str(tsc.indexOfClosestPoint.data(ii)),                  '-';...
            'Offset From Closest Index',num2str(tsc.offsetFromStart.data(ii)),                      '-';...
            'Speed',                    num2str(tsc.BFXDot.data(ii)),                               'm/s';...
%             'Signed Spatial Error',     num2str(tsc.signedSpatialError.data(ii)),                   'm';...
%             'Spatial ILC First Term',   num2str(tsc.spatialILCFirstTerm.data(ii)),                  'rad';...
%             'Spatial ILC Correction',   num2str(tsc.spatialILCCorrection.data(ii)),                 'rad';...
            'Heading Setpoint',         sprintf('%.4f',tsc.headingSetpoint.data(ii)*(180/pi)),      'deg';...
            'Heading Desired',          sprintf('%.4f',tsc.headingDes.data(ii)*(180/pi)),           'deg';...
            'Heading',                  sprintf('%.4f',tsc.heading.data(ii)*(180/pi)),              'deg';...
            'Basis Param: Azimuth',     sprintf('%.4f',tsc.basisParams.data(ii,1)*(180/pi)),        'deg';...
            'Basis Param: Zenith',      sprintf('%.4f',tsc.basisParams.data(ii,2)*(180/pi)),        'deg';
            'Wind Speed',               sprintf('%.4f',sum(tsc.vWindGFC.data(ii,:).^2)^(1/2)),      'm/s'
            'Apparent Wind Speed',      sprintf('%.4f',sum(tsc.vAppWindGFC.data(ii,:).^2)^(1/2)),   'm/s';...
            'Wing Angle Command, $u_w$',sprintf('%.4f',tsc.wingAngleCommand.data(ii)*180/pi),       'deg';...
            'Gamma Wing',               sprintf('%.4f',tsc.gammaWing.data(ii)*180/pi),              'deg';
            'AlphaWing',                sprintf('%.4f',tsc.alphaWing.data(ii)*180/pi),     'deg';...
            'Wing Net Long. Force',     sprintf('%.4f',tsc.fNetBFC.data(ii,1)),                     'N';...
            'Gamma Rudder',             sprintf('%.4f',tsc.gammaRudder.data(ii)*180/pi),            'deg';...
            'Rudder Sat. Indicator',    sprintf('%.4f',tsc.rudderSaturationIndicator.data(ii)),     '-';...
            'Rudder Command',           sprintf('%.4f',tsc.rudderAngleCommand.data(ii)*180/pi),     'deg';...
            'Rudder Angle',             sprintf('%.4f',tsc.rudderAngle.data(ii)*180/pi),           'deg';...
            'Alpha Rudder',             sprintf('%.4f',tsc.alphaRudder.data(ii)*180/pi),   'deg';...
            'Rudder Coeff of Lift',     sprintf('%.4f',tsc.ClRudder.data(ii)),                      '-';...
            'Moment About z',           sprintf('%.4f',tsc.MzBFC.data(ii)),                         'Nm'};
        
        h.table = uitable('Data',data,'ColumnName',colNames,...
            'Units', 'Normalized');
        h.table.Position = [0, 0, 0.25, 1];
        h.table.FontSize = 16;
        h.table.ColumnWidth = {240,120,'auto'};
         
    else
        
        % Add a point to the end of the position data
        h.position.XData = [h.position.XData tsc.positionGFC.data(ii,1)];
        h.position.YData = [h.position.YData tsc.positionGFC.data(ii,2)];
        h.position.ZData = [h.position.ZData tsc.positionGFC.data(ii,3)];
        h.position.CData = [h.position.CData; pathColors(ii,:)];
        
        % Move the target point
        h.targetWaypoint.XData = tsc.targetPointGFC.data(ii,1);
        h.targetWaypoint.YData = tsc.targetPointGFC.data(ii,2);
        h.targetWaypoint.ZData = tsc.targetPointGFC.data(ii,3);
        
        % Move the closest point
        h.closestPoint.XData = tsc.closestPointGFC.data(ii,1);
        h.closestPoint.YData = tsc.closestPointGFC.data(ii,2);
        h.closestPoint.ZData = tsc.closestPointGFC.data(ii,3);
        
        % Update the body fixed x-axis
        h.BFX.XData = tsc.positionGFC.data(ii,1);
        h.BFX.YData = tsc.positionGFC.data(ii,2);
        h.BFX.ZData = tsc.positionGFC.data(ii,3);
        h.BFX.UData = axesScaleFactor*tsc.BFX_GFC.data(ii,1);
        h.BFX.VData = axesScaleFactor*tsc.BFX_GFC.data(ii,2);
        h.BFX.WData = axesScaleFactor*tsc.BFX_GFC.data(ii,3);
        
        
        % Update the body fixed y-axis
        h.BFY.XData = tsc.positionGFC.data(ii,1);
        h.BFY.YData = tsc.positionGFC.data(ii,2);
        h.BFY.ZData = tsc.positionGFC.data(ii,3);
        h.BFY.UData = axesScaleFactor*tsc.BFY_GFC.data(ii,1);
        h.BFY.VData = axesScaleFactor*tsc.BFY_GFC.data(ii,2);
        h.BFY.WData = axesScaleFactor*tsc.BFY_GFC.data(ii,3);
        
        % Update the rudder angle plot
        h.rudder.XData = sin(tsc.rudderAngle.data(ii))*[1 -1];
        h.rudder.YData = cos(tsc.rudderAngle.data(ii))*[-1 1];
        
        % Update the wind in the rudder angle plot
        h.apparentWindRudder.XData = [sin(tsc.gammaRudder.data(ii)) 0];
        h.apparentWindRudder.YData = [cos(tsc.gammaRudder.data(ii)) 0];
        
        % Update the wing angle plot
        h.wing.XData = cos(tsc.wingAngle.data(ii))*[-1 1];
        h.wing.YData = sin(tsc.wingAngle.data(ii))*[-1 1];
        
        % upda
        h.apparentWindWing.XData = cos(tsc.gammaWing.data(ii))*[1 0];
        h.apparentWindWing.YData = sin(tsc.gammaWing.data(ii))*[-1 0];

        h.table.Data(:,2)={...
            sprintf('%.3f',tsc.time(ii)),;...
            num2str(ii);...
            num2str(p.Ts);...
            num2str(1/frameRate);...
            num2str(tsc.currentIterationNumber.data(ii));...
            sprintf('%.4f',tsc.minimumDistanceToPath.data(ii));...
            num2str(tsc.indexOfClosestPoint.data(ii));...
            num2str(tsc.offsetFromStart.data(ii));...
            num2str(tsc.BFXDot.data(ii));...
%             num2str(tsc.signedSpatialError.data(ii));...
%             num2str(tsc.spatialILCFirstTerm.data(ii))
%             num2str(tsc.spatialILCCorrection.data(ii))
            sprintf('%.4f',tsc.headingSetpoint.data(ii)*(180/pi));...
            sprintf('%.4f',tsc.headingDes.data(ii)*(180/pi));...
            sprintf('%.4f',tsc.heading.data(ii)*(180/pi));...
            sprintf('%.4f',tsc.basisParams.data(ii,1)*(180/pi));...
            sprintf('%.4f',tsc.basisParams.data(ii,2)*(180/pi));...
            sprintf('%.4f',sum(tsc.vWindGFC.data(ii,:).^2)^(1/2));...
            sprintf('%.4f',sum(tsc.vAppWindGFC.data(ii,:).^2)^(1/2));...
            sprintf('%.4f',tsc.wingAngleCommand.data(ii)*180/pi);...
            sprintf('%.4f',tsc.gammaWing.data(ii)*180/pi);...
            sprintf('%.4f',tsc.alphaWing.data(ii)*180/pi);...
            sprintf('%.4f',tsc.fNetBFC.data(ii,1));...
            sprintf('%.4f',tsc.gammaRudder.data(ii)*180/pi);...
            sprintf('%.4f',tsc.rudderSaturationIndicator.data(ii));...
            sprintf('%.4f',tsc.rudderAngleCommand.data(ii)*180/pi);...
            sprintf('%.4f',tsc.rudderAngle.data(ii)*180/pi);...
            sprintf('%.4f',tsc.alphaRudder.data(ii)*180/pi);...
            sprintf('%.4f',tsc.ClRudder.data(ii));...
            sprintf('%.4f',tsc.MzBFC.data(ii))};
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

v = VideoWriter(videoFilePath,'MPEG-4');
open(v);
writeVideo(v,frame)
close(v)
end