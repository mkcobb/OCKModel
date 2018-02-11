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
p.numSettlingLaps       = 10;
p.numInitializationLaps = 5;
p.numOptimizationLaps   = 10;
p.waypointAzimuthTol    = 1*(pi/180);

p.width = 97.78;
p.height = 16.11;

startCallback
sim('CDCJournalModel')
stopCallback


%%
waypointUpdateTrigger = getElement(logsout,'waypointUpdateTrigger');
waypointUpdateTrigger = waypointUpdateTrigger.Values;

performanceIndex = getElement(logsout,'performanceIndex');
performanceIndex = performanceIndex.Values;

performanceIndex = getElement(logsout,'performanceIndex');
performanceIndex = performanceIndex.Values;

meanPAR = getElement(logsout,'meanPAR');
meanPAR = meanPAR.Values;

normalizedSpatialError = getElement(logsout,'normalizedSpatialError');
normalizedSpatialError = normalizedSpatialError.Values;

close all

figure
ax1 = subplot(5,1,1);
plot(waypointUpdateTrigger.data)
ylabel('Waypoint Updt. Trigger')

ax2 = subplot(5,1,2);
plot(performanceIndex.data)
ylabel('Online J')

ax3 = subplot(5,1,3);
plot(meanPAR.data)
ylabel('Mean PAR')

ax4 = subplot(5,1,4);
plot(normalizedSpatialError.data)
ylabel('NSE')

ax5 = subplot(5,1,5);
plot(meanPAR.data-p.weightNSE*normalizedSpatialError.data)
ylabel('Offline J')

linkaxes([ax1 ax2 ax3 ax4 ax5],'x')

