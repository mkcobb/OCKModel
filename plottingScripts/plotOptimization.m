close all


%% Plot Design Space Trajectory
figure
hax=gca;
plot3(iter.basisParams(:,1)*(180/pi),iter.basisParams(:,2)*(180/pi),iter.performanceIndex)
grid on
hold on

hold on
filePath = fullfile(fileparts(fileparts(which(mfilename))),'gridResults');
fileName = fullfile(filePath,'results_n_8.mat');
load(fileName,'widths','heights','meanPAR','maxSpatialError','normalizedSpatialError')

if p.switchMSE
    zData = meanPAR - p.weightMSE*maxSpatialError;
    surf(widths,heights,zData,'Parent',hax);
    
elseif p.switchNSE
    zData = meanPAR - p.weightNSE*normalizedSpatialError;
    surf(widths,heights,zData,'Parent',hax)
end

widths  = linspace(min(iter.basisParams(:,1)),max(iter.basisParams(:,1)),100);
heights = linspace(min(iter.basisParams(:,2)),max(iter.basisParams(:,2)),100);
[widths,heights]= meshgrid(widths,heights);
beta = iter.beta(end,:);
if any(beta==inf)
    beta=iter.beta(end-1,:);
end
estimatedPerformance = beta(1) +beta(2)*widths+beta(3)*widths.^2+beta(4)*heights+beta(5)*heights.^2;
estimatedPerformance(estimatedPerformance<min(min(zData)))=NaN;
estimatedPerformance(estimatedPerformance>max(max(zData)))=NaN;
hEstSurf=surf((180/pi)*widths,(180/pi)*heights,estimatedPerformance);

% xlim([min(min(widths)) max(max(widths))])
% ylim([min(min(heights)) max(max(heights))])
% zlim([min(min(zData)) max(max(zData))])


%% Plot performance index
% figure
% subplot(2,2,1)
% plot(iter.performanceIndex(p.numSettlingLaps:end-1),...
%     'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
% addPhaseMarkers
% grid on
% xlim([1 max([length(iter.performanceIndex(p.numSettlingLaps:end-1)) 2])])
% ylim(yLimits)
% xlabel('Iteration Number')
% ylabel('Performance Index')
% set(gca,'FontSize',20)
% 
% subplot(2,2,2)
% plot(iter.normalizedSpatialError(p.numSettlingLaps:end-1),...
%     'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
% addPhaseMarkers
% grid on
% xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
% ylim(yLimits)
% xlabel('Iteration Number')
% ylabel({'Normalized','Spatial Error'})
% set(gca,'FontSize',20)
% 
% subplot(2,2,3)
% plot(iter.meanPAR(p.numSettlingLaps:end-1),...
%     'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
% addPhaseMarkers
% grid on
% xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
% ylim(yLimits)
% xlabel('Iteration Number')
% ylabel({'Mean PAR','Term'})
% set(gca,'FontSize',20)
% 
% subplot(2,2,4)
% plot(p.weightMSE*iter.maxSpatialError(p.numSettlingLaps:end-1),...
%     'LineWidth',1,'Marker','none','MarkerFaceColor','k','MarkerEdgeColor','k')
% addPhaseMarkers
% grid on
% xlim([1 length(iter.performanceIndex(p.numSettlingLaps:end-1))])
% ylim(yLimits)
% xlabel('Iteration Number')
% ylabel({'Max Spatial','Error Term'})
% set(gca,'FontSize',20)
% 
% 
% 

