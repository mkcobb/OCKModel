
%% PLOT VARIABLE SPEED RESULTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot the variable wind profile
% close all;bdclose all;clear;clc;
% file = dir(fullfile(pwd,'data','*NREL*.mat'));
% load(fullfile(file.folder,file.name),'iter','windData','p');
% 
% % Plot wind profile
% h.windSpeed = figure;
% h.windSpeedPlot = plot(windData.NREL);
% grid on
% axis tight
% set(gca,'LooseInset',get(gca,'TightInset'))
% set(gcf,'color','white')
% set(h.windSpeedPlot,'Color','k');
% xlim([0 p.T])
% xlabel('Time, t [s]','Interpreter','Latex')
% ylabel('Wind Speed, [m$\cdot$s$^{-1}$]','Interpreter','Latex')
% title('NREL Wind Profile','Interpreter','Latex')
% set(gca,'FontSize',36)
% saveas(h.windSpeed,fullfile(pwd,'figures','png','windProfile.png'));
% saveas(h.windSpeed,fullfile(pwd,'figures','eps','windProfile.eps'),'epsc')
% saveas(h.windSpeed,fullfile(pwd,'figures','fig','windProfile.fig'))

%% Plot the performance index vs iteration and time
% close all;bdclose all;clear;clc;
% 
% files = dir(fullfile(pwd,'data','*NREL*.mat'));
% positionMod = [-0.05 0 0.1 -0.15];
% 
% h.fig = figure;
% ax1=subplot(2,1,1);
% ax2=subplot(2,1,2);
% 
% hold(ax1,'on')
% hold(ax2,'on')
% 
% for ii = 1:length(files)
%     
%     load(fullfile(files(ii).folder,files(ii).name),'iter','windData','p');
%     
%     
%     h.plot1{ii} = plot(iter.performanceIndex(p.numSettlingLaps+1:end),...
%         'Parent',ax1,'LineWidth',2,'DisplayName',...
%         sprintf('$k_e=%.1f$',p.KLearningNewton),'Color','k');
%     
%     h.plot2{ii} = plot(iter.times(p.numSettlingLaps+1:end)./60,...
%         iter.performanceIndex(p.numSettlingLaps+1:end),...
%         'Parent',ax2,'LineWidth',2,'DisplayName',...
%         sprintf('$k_e=%.1f$',p.KLearningNewton),'Color','k');
%     
% end
% xlabel(ax1,'Iteration Number,$j$')
% ylabel(ax1,{'Performance','Index, $J_j$'})
% xlabel(ax2,'Time, $t$ [min]')
% ylabel(ax2,{'Performance','Index, $J_j$'})
% axis(ax1,'tight')
% axis(ax2,'tight')
% box(ax1,'off')
% box(ax2,'off')
% grid(ax1,'on')
% grid(ax2,'on')
% leg1=legend(ax1);
% leg1.Location = 'southeast';
% leg1.Orientation = 'horizontal';
% leg2=legend(ax2);
% leg2.Location = leg1.Location;
% leg2.Orientation = leg1.Orientation;
% ax1.FontSize = 30;
% ax2.FontSize = ax1.FontSize;
% h.plot1{2}.LineStyle = '-';
% h.plot2{2}.LineStyle = h.plot1{2}.LineStyle;
% h.plot1{2}.Color = 0.5*[1 1 1];
% h.plot2{2}.Color = h.plot1{2}.Color;
% title(ax1,'Performance Index Vs Iteration Number and Time')
% 
% saveas(h.fig,fullfile(pwd,'figures','png','performanceIndexVariableWind.png'));
% saveas(h.fig,fullfile(pwd,'figures','eps','performanceIndexVariableWind.eps'),'epsc')
% saveas(h.fig,fullfile(pwd,'figures','fig','performanceIndexVariableWind.fig'))

%% Plot the PAR vs iteration and time
% close all;bdclose all;clear;clc;
% 
% files = dir(fullfile(pwd,'data','*NREL*.mat'));
% positionMod = [-0.05 0 0.1 -0.15];
% 
% h.fig = figure;
% ax1=subplot(2,1,1);
% ax2=subplot(2,1,2);
% 
% hold(ax1,'on')
% hold(ax2,'on')
% 
% for ii = 1:length(files)
%     
%     load(fullfile(files(ii).folder,files(ii).name),'iter','windData','p');
%     
%     
%     h.plot1{ii} = plot(iter.meanPAR(p.numSettlingLaps+1:end),...
%         'Parent',ax1,'LineWidth',2,'DisplayName',...
%         sprintf('$k_e=%.1f$',p.KLearningNewton),'Color','k');
%     
%     h.plot2{ii} = plot(iter.times(p.numSettlingLaps+1:end)./60,...
%         iter.meanPAR(p.numSettlingLaps+1:end),...
%         'Parent',ax2,'LineWidth',2,'DisplayName',...
%         sprintf('$k_e=%.1f$',p.KLearningNewton),'Color','k');
%     
% end
% xlabel(ax1,'Iteration Number, $j$')
% ylabel(ax1,{'PAR'})
% xlabel(ax2,'Time, $t$ [min]')
% ylabel(ax2,{'PAR'})
% axis(ax1,'tight')
% axis(ax2,'tight')
% box(ax1,'off')
% box(ax2,'off')
% grid(ax1,'on')
% grid(ax2,'on')
% leg1=legend(ax1);
% leg1.Location = 'best';
% leg1.Orientation = 'horizontal';
% leg2=legend(ax2);
% leg2.Location = 'best';
% leg2.Orientation = leg1.Orientation;
% ax1.FontSize = 30;
% ax2.FontSize = ax1.FontSize;
% h.plot1{2}.LineStyle = '-';
% h.plot2{2}.LineStyle = h.plot1{2}.LineStyle;
% h.plot1{2}.Color = 0.5*[1 1 1];
% h.plot2{2}.Color = h.plot1{2}.Color;
% title(ax1,'PAR Vs Iteration Number and Time')
% 
% saveas(h.fig,fullfile(pwd,'figures','png','PARVariableWind.png'));
% saveas(h.fig,fullfile(pwd,'figures','eps','PARVariableWind.eps'),'epsc')
% saveas(h.fig,fullfile(pwd,'figures','fig','PARVariableWind.fig'))

%% PLOT CONSTANT SPEED RESULTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PLOT THE PATH GEOMETRY EVOLUTIONS
% close all;clear;clc;
% styles = {'-','--','-.',':','-'};
% colors = {'k','b','r','g','k'};
% markers = {'x','o','+','d','^'};
% 
% % Find all the files located in data which contain substring 'Constant'
% files = dir(fullfile(pwd,'data','*Constant*.mat'));
% 
% for fileNum = 1:length(files)
%     load(fullfile(pwd,'data',files(fileNum).name),'iter','windData','p')
%     figureHandle = figure;
%     switch p.ic
%         case 'both'
%             icNumber = 3;
%             iterations = p.numSettlingLaps+p.numInitializationLaps+1+20*[0 1 2 3 4];
%         case 'wide'
%             icNumber = 2;
%             iterations = p.numSettlingLaps+p.numInitializationLaps+1+20*[0 1 2 3 4];
%         case 'short'
%             icNumber = 1;
%             iterations = p.numSettlingLaps+p.numInitializationLaps+1+50*[0 1 2 3 4];
%     end
%     
%     for ii = 1:length(iterations)
%         b = iter.basisParams(iterations(ii),:);
%         w = generateWaypoints(40,b(2),b(1),pi/4);
%         w = [w.thetaDeg',w.phiDeg'];
%         w = [w(end,:);w(:,:)];
%         h = plot((180/pi)*w(:,1),(180/pi)*w(:,2));
%         hold on
%         h.MarkerSize = 15;
%         h.Marker = markers{ii};
%         h.Color = colors{ii};
%         h.LineStyle = styles{ii};
%         h.DisplayName = sprintf('$j=%d$',iterations(ii)-(p.numSettlingLaps+p.numInitializationLaps+1));
%     end
%     grid on
%     leg = legend;
%     leg.Interpreter = 'Latex';
%     axis tight
%     set(gca,'FontSize',30)
%     xlabel('Waypoint Azimuth Position, $\Theta_i$ [deg]','Interpreter','Latex')
%     ylabel('Waypoint Zenith Position, $\Phi_i$ [deg]','Interpreter','Latex')
%     title(sprintf('Path Geometry Evolution: Initial Path Geometry %d',icNumber),'Interpreter','Latex')
%     
%     saveas(figureHandle,fullfile(pwd,'figures','png',sprintf('pathGeometryEvolution%d.png',icNumber)));
%     saveas(figureHandle,fullfile(pwd,'figures','eps',sprintf('pathGeometryEvolution%d.eps',icNumber)),'epsc')
%     saveas(figureHandle,fullfile(pwd,'figures','fig',sprintf('pathGeometryEvolution%d.fig',icNumber)))
% end

%% PLOT DESIGN SPACE
% close all;clear;clc;
% % Find all the files located in data which contain substring 'Constant'
% files = dir(fullfile(pwd,'data','*Constant*.mat'));
% figureHandle = figure;
% widthRange = [NaN NaN];
% heightRange = widthRange;
% for ii = 1:length(files)
%    load(fullfile(pwd,'data',files(ii).name),'iter','windData','p');
%    h{ii} = plot3((180/pi)*iter.basisParams(p.numSettlingLaps+1:end,1),...
%        (180/pi)*iter.basisParams(p.numSettlingLaps+1:end,2),....
%        iter.performanceIndex(p.numSettlingLaps+1:end));
%    legendName = lower(strtok(files(ii).name,'_'));
%    legendName(1) = upper(legendName(1));
%    h{ii}.DisplayName = [legendName ' Initial Cond.'];
%    hold on
%    widthRange = [min([widthRange(1);(180/pi)*iter.basisParams(p.numSettlingLaps+1:end,1)])...
%        max([widthRange(2);(180/pi)*iter.basisParams(p.numSettlingLaps+1:end,1)])];
%    heightRange = [min([heightRange(1);(180/pi)*iter.basisParams(p.numSettlingLaps+1:end,2)])...
%        max([heightRange(2);(180/pi)*iter.basisParams(p.numSettlingLaps+1:end,2)])];
% end
% grid on
% xlabel('Path Width, $W_j$ [deg]','Interpreter','Latex')
% ylabel('Path Height, $H_j$ [deg]','Interpreter','Latex')
% title('Performance Index Vs Iteration Number','Interpreter','Latex')
% zlabel('Performance Index, $J_j$','Interpreter','Latex')
% axis tight
% leg=legend;
% leg.Location = 'NorthEast';
% view([35.5 12.8])
% h{1}.Color = 'k';
% h{2}.Color = 'b';
% h{3}.Color = 'r';
% 
% h{1}.LineStyle = '-';
% h{2}.LineStyle = '-.';
% h{3}.LineStyle = ':';
% 
% set(gca,'FontSize',30)
% saveas(figureHandle,fullfile(pwd,'figures','png','designSpaceConstantWind.png'));
% saveas(figureHandle,fullfile(pwd,'figures','eps','designSpaceConstantWind.eps'),'epsc')
% saveas(figureHandle,fullfile(pwd,'figures','fig','designSpaceConstantWind.fig'))

%% PLOT PERFORMANCE INDEX
close all;clear;clc;

files = dir(fullfile(pwd,'data','*Constant*.mat'));
figureHandle = figure;
ax1 = subplot(2,1,1);
ax2 = subplot(2,1,2);
h1={};h2={};
for ii = 1:length(files)
   load(fullfile(pwd,'data',files(ii).name),'iter','windData','p');
   switch p.ic
       case 'both'
           icNumber = 3;
       case 'wide'
           icNumber = 2;
       case 'short'
           icNumber = 1;
   end
   if icNumber ~=3
       axes(ax1)
       h1{end+1} = plot(iter.performanceIndex(p.numSettlingLaps+1:end),'Parent',ax1,'LineWidth',2);
       h1{end}.DisplayName = sprintf('Initial Path Geometry %d',icNumber);
       hold on
       axes(ax2)
       h2{end+1} = plot(iter.times(p.numSettlingLaps+1:end)./60,...
           iter.performanceIndex(p.numSettlingLaps+1:end),...
           'Parent',ax2,'LineWidth',2);
       h2{end}.DisplayName = sprintf('Initial Path Geometry %d',icNumber);
       hold on
   end
end


axes(ax1)
box off
grid on
xlbl = xlabel('Iteration Number, $j$','Interpreter','Latex');
xlbl.Units ='normalized';
xlbl.Position = xlbl.Position + [0 -0.05 0];
ylabel({'Performance','Index, $J_j$'},'Interpreter','Latex')

xRange = [0 min([length(h1{1}.XData) length(h1{2}.XData)])];
xlim(xRange)
yRange(1) = min([h1{1}.YData(1:xRange(2)) ...
    h1{2}.YData(1:xRange(2))]);
yRange(2)= max([h1{1}.YData(1:xRange(2)) ...
    h1{2}.YData(1:xRange(2))]);
ylim(yRange)
h1{1}.Color = 'k';
h1{2}.Color = 0.5*[1 1 1];
title('Performance Index Vs Iteration Number and Time')

h1{1}.LineStyle = '-';
h1{2}.LineStyle = '-';


leg = legend;
leg.Location='SouthEast';



set(gca,'FontSize',30)


axes(ax2)
box off
grid on
xlbl = xlabel('Time, $t$ [min]','Interpreter','Latex');
xlbl.Units ='normalized';
xlbl.Position = xlbl.Position + [0 -0.05 0];
ylabel({'Performance','Index, $J_j$'},'Interpreter','Latex')

xRange = [0 min([h2{1}.XData(xRange(2)) h2{2}.XData(xRange(2)) ])];
xlim(xRange)


ylim(ax1.YLim)

h2{1}.Color = 'k';
h2{2}.Color = 0.5*[1 1 1];


h2{1}.LineStyle = '-';
h2{2}.LineStyle = '-';


leg=legend;
leg.Location='SouthEast';


set(gca,'FontSize',30)
saveas(figureHandle,fullfile(pwd,'figures','png','performanceIndexConstantWind.png'));
saveas(figureHandle,fullfile(pwd,'figures','eps','performanceIndexConstantWind.eps'),'epsc')
saveas(figureHandle,fullfile(pwd,'figures','fig','performanceIndexConstantWind.fig'))