close all;clear;clc;bdclose all;

preLoadCallback;
load_system('CDCJournalModel')

p.runMode       = 2;
p.windVariant   = 1;
p.vWind         = 7;
p.ic            = 'userspecified';
p.num           = 8;
p.tauR          = 0.05;
p.plotsOnOff    = 0;
p.soundOnOff    = 0;
p.saveOnOff     = 0;
p.verbose       = 0;
p.numSettlingLaps       = 5;
p.numInitializationLaps = 5;
p.numOptimizationLaps   = 10;
p.waypointAzimuthTol    = 1*(pi/180);

widths  = linspace(20,120,10);
heights = linspace(5,25,10);
[widths,heights] = meshgrid(widths,heights);

meanPAR = NaN * zeros(size(widths));
normalizedSpatialError      = meanPAR;
maxSpatialError             = meanPAR;
momentBasedControlEnergy    = meanPAR;
commandBasedControlEnergy   = meanPAR;

hFig = figure;

for ii = 1:numel(widths)
        fprintf('\nRunning %d/%d...',ii,numel(widths))
        
        p.width = widths(ii);
        p.height = heights(ii);

        startCallback
        sim('CDCJournalModel')
        stopCallback

        if tsc.gridPointCompleteFlag.data(end)
            fprintf(' Performance Index = %d',iter.performanceIndex(end))
            meanPAR(ii)                     = iter.meanPAR(end);
            normalizedSpatialError(ii)      = iter.normalizedSpatialError(end);
            maxSpatialError(ii)             = iter.maxSpatialError(end);
            momentBasedControlEnergy(ii)    = iter.momentBasedControlEnergy(end);
            commandBasedControlEnergy(ii)   = iter.commandBasedControlEnergy(end);
%             updateResponseSurfacePlot
        end
end
save(fullfile(pwd,'gridResults',sprintf('results_n_%d.mat',p.num)),'widths','heights','meanPAR',...
    'normalizedSpatialError','momentBasedControlEnergy','commandBasedControlEnergy','maxSpatialError','p')
fprintf('\n')


