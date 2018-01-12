
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
% file = dir(fullfile(pwd,'data','*NREL*.mat'));
% load(fullfile(file.folder,file.name),'iter','windData','p');

% positionMod = [-0.05 0 0.1 -0.15];

% %Plot the performance index
% h.performanceIndex = figure;
% % First axes
% plot(iter.performanceIndex(p.numSettlingLaps+1:end))
% ax1 = gca;
% xlabel('Iteration Number,$j$')
% ylabel('')
% ax1.YTick = [];
% ax1.FontSize = 30;
% ax1.Box = 'off';
% ax1.YGrid = 'on';
% ax1.TickDir = 'out';
% xlim([0 length(iter.meanPAR)])
% ax1.Position = ax1.Position + positionMod;
% h.performanceIndex.Color = [1 1 1];
% % Second axes
% ax2 = axes('Position',ax1.Position);
% plot(iter.times(p.numSettlingLaps+1:end),iter.performanceIndex(p.numSettlingLaps+1:end),'Parent',ax2,'Color','k')
% ax2.YGrid = 'on';
% ax2.Box = 'off';
% xlim([0 iter.times(end)])
% % ax2.YTick = [];
% ax2.XAxisLocation = 'top';
% xlabel('Time, t [s]')
% ylabel('Performance Index, $J_j$')
% title('Performance Index Vs Iteration Number')
% set(gca,'FontSize',30)
% saveas(h.performanceIndex,fullfile(pwd,'figures','png','performanceIndexVariableWind.png'));
% saveas(h.performanceIndex,fullfile(pwd,'figures','eps','performanceIndexVariableWind.eps'),'epsc')
% saveas(h.performanceIndex,fullfile(pwd,'figures','fig','performanceIndexVariableWind.fig'))

%% Plot the PAR vs iteration and time
% close all;bdclose all;clear;clc;
% 
% file = dir(fullfile(pwd,'data','*NREL*.mat'));
% load(fullfile(file.folder,file.name),'iter','windData','p');


% positionMod = [-0.05 0 0.1 -0.15];
% 
% % Plot the performance index
% h.PAR = figure;
% % First axes
% plot(iter.meanPAR(p.numSettlingLaps+1:end))
% ax1 = gca;
% xlabel('Iteration Number,$j$')
% ylabel('')
% ax1.YTick = [];
% xlim([0 length(iter.meanPAR)])
% ax1.FontSize = 30;
% ax1.Box = 'off';
% ax1.YGrid = 'on';
% ax1.TickDir = 'out';
% ax1.Position = ax1.Position + positionMod;
% h.performanceIndex.Color = [1 1 1];
% % Second axes
% ax2 = axes('Position',ax1.Position);
% plot(iter.times(p.numSettlingLaps+1:end),iter.meanPAR(p.numSettlingLaps+1:end),'Parent',ax2,'Color','k')
% ax2.YGrid = 'on';
% xlim([0 iter.times(end)])
% ax2.Box = 'off';
% ax2.FontSize = 30;
% ax2.XAxisLocation = 'top';
% xlabel('Time, t [s]')
% ylabel('PAR')
% title('PAR Vs Iteration Number')
% 
% saveas(h.PAR,fullfile(pwd,'figures','png','PARVariableWind.png'));
% saveas(h.PAR,fullfile(pwd,'figures','eps','PARVariableWind.eps'),'epsc')
% saveas(h.PAR,fullfile(pwd,'figures','fig','PARVariableWind.fig'))

%% PLOT CONSTANT SPEED RESULTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PLOT THE COURSE GEOMETRY EVOLUTION
close all;clear;clc;
% Find all the files located in data which contain substring 'Constant'
files = dir(fullfile(pwd,'data','*Constant*.mat'));
load(fullfile(pwd,'data',files(1).name),'iter','windData','p')
figureHandle = figure;
iterations = p.numSettlingLaps+p.numInitializationLaps+1+15*[0 1 2 3 4];
styles = {'-','--','-.',':','-'};
colors = {'k','b','r','g','k'};
markers = {'x','o','+','d','x'};

for ii = 1:length(iterations)
   b = iter.basisParams(iterations(ii),:);
   w = generateWaypoints(40,b(2),b(1),pi/4);
   w = [w.thetaDeg',w.phiDeg'];
   w = [w(end,:);w(:,:)];
   h = plot((180/pi)*w(:,1),(180/pi)*w(:,2));
   hold on
   h.MarkerSize = 15;
   h.Marker = markers{ii};
   h.Color = colors{ii};
   h.LineStyle = styles{ii};
   h.DisplayName = sprintf('Iteration %d',iterations(ii)-(p.numSettlingLaps+p.numInitializationLaps+1));
end
grid on
legend
set(gca,'FontSize',30)
xlabel('Waypoint Azimuth Position, $\Theta_i$ [deg]','Interpreter','Latex')
ylabel('Waypoint Zenith Position, $\Phi_i$ [deg]','Interpreter','Latex')
title('Course Geometry Evolution','Interpreter','Latex')

saveas(figureHandle,fullfile(pwd,'figures','png','courseGeometryEvolution.png'));
saveas(figureHandle,fullfile(pwd,'figures','eps','courseGeometryEvolution.eps'),'epsc')
saveas(figureHandle,fullfile(pwd,'figures','fig','courseGeometryEvolution.fig'))

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
% xlabel('Course Width, $W_j$ [deg]','Interpreter','Latex')
% ylabel('Course Height, $H_j$ [deg]','Interpreter','Latex')
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
% close all;clear;clc;
% % Find all the files located in data which contain substring 'Constant'
% files = dir(fullfile(pwd,'data','*Constant*.mat'));
% figureHandle = figure;
% 
% for ii = 1:length(files)
%    load(fullfile(pwd,'data',files(ii).name),'iter','windData','p');
%    h{ii} = plot(iter.performanceIndex(p.numSettlingLaps+1:end));
%    legendName = lower(strtok(files(ii).name,'_'));
%    legendName(1) = upper(legendName(1));
%    h{ii}.DisplayName = [legendName ' Initial Cond.'];
%    hold on
% end
% grid on
% xlabel('Iteration Number, $j$','Interpreter','Latex')
% ylabel('Performance Index, $J_j$','Interpreter','Latex')
% title('Performance Index Vs Iteration Number','Interpreter','Latex')
% xlim([0 length(iter.meanPAR)])
% 
% h{1}.Color = 'k';
% h{2}.Color = 'b';
% h{3}.Color = 'r';
% 
% h{1}.LineStyle = '-';
% h{2}.LineStyle = '-.';
% h{3}.LineStyle = ':';
% axis tight
% leg=legend;
% leg.Location='SouthEast';
% 
% set(gca,'FontSize',30)
% saveas(figureHandle,fullfile(pwd,'figures','png','performanceIndexConstantWind.png'));
% saveas(figureHandle,fullfile(pwd,'figures','eps','performanceIndexConstantWind.eps'),'epsc')
% saveas(figureHandle,fullfile(pwd,'figures','fig','performanceIndexConstantWind.fig'))
