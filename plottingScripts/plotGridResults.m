close all;clear;clc;bdclose all;
filePath = fullfile(fileparts(fileparts(which(mfilename))),'gridResults');
fileName = fullfile(filePath,'results_n_8_tauR_0.02.mat');

p = simulationParametersClass;

load(fileName)

% Plot all independently
hFig1  = figure;
axPAR = subplot(2,2,1);
hSurfPAR = surf(widths,heights,meanPAR);
hold on
[~,index] = max(meanPAR(:));
hMaxPointPAR = scatter3(widths(index),heights(index),meanPAR(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel(axPAR,'W')
ylabel(axPAR,'H')
zlabel(axPAR,'PAR')

axNSE = subplot(2,2,2);
hSurfNSE = surf(widths,heights,normalizedSpatialError);
hold on
[~,index] = max(normalizedSpatialError(:));
hMaxPointNSE = scatter3(widths(index),heights(index),normalizedSpatialError(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel(axNSE,'W')
ylabel(axNSE,'H')
zlabel(axNSE,'NSE')

axMCE = subplot(2,2,3);
hSurfMCE = surf(widths,heights,momentBasedControlEnergy);
hold on
[~,index] = max(momentBasedControlEnergy(:));
hMaxPointMCE = scatter3(widths(index),heights(index),momentBasedControlEnergy(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel(axMCE,'W')
ylabel(axMCE,'H')
zlabel(axMCE,'MCE')

axCCE = subplot(2,2,4);
hSurfCCE = surf(widths,heights,commandBasedControlEnergy);
hold on
[~,index] = max(commandBasedControlEnergy(:));
hMaxPointCCE = scatter3(widths(index),heights(index),commandBasedControlEnergy(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel(axCCE,'W')
ylabel(axCCE,'H')
zlabel(axCCE,'CCE')

saveas(hFig1,fullfile(filePath,'IndividualComponents_n_40.fig'))

hFig2 = figure;
data = meanPAR-p.PARTrackingWeight*normalizedSpatialError;
axPARNSE = surf(widths,heights,data);
hold on
[~,index] = max(data(:));
hMaxPointPARNSE = scatter3(widths(index),heights(index),data(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel('W')
ylabel('H')
zlabel('PAR - K*NSE')
title(sprintf('PAR - %d*NSE',p.PARTrackingWeight))

saveas(hFig1,fullfile(filePath,'PARNSE_n_40.fig'))

hFig3 = figure;
CCEWeight = 800;
data = meanPAR-CCEWeight*commandBasedControlEnergy;
axPARCCE = surf(widths,heights,data);
hold on
[~,index] = max(data(:));
hMaxPointPARCCE = scatter3(widths(index),heights(index),data(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
xlabel('W')
ylabel('H')
zlabel(sprintf('PAR - %d*CCE',CCEWeight))
title(sprintf('PAR - %d*CCE',CCEWeight))

saveas(hFig1,fullfile(filePath,'PARCCE_n_40.fig'))

hFig4 = figure;
MCEWeight = 0.009;
data = meanPAR-MCEWeight*momentBasedControlEnergy;
hold on
[~,index] = max(data(:));
hMaxPointPARMCE = scatter3(widths(index),heights(index),data(index),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
axPARMCE = surf(widths,heights,data);
xlabel('W')
ylabel('H')
zlabel(sprintf('PAR - %d*MCE',MCEWeight))
title(sprintf('PAR - %d*MCE',MCEWeight))

saveas(hFig1,fullfile(filePath,'PARMCE_n_40.fig'))
